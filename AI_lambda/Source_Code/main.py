from __future__ import annotations
import json
import logging
from typing import Dict, Any
from datetime import datetime
from openai import OpenAI
from config import Config
from tailored_utils import call_function, select_tools

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def _parse_body(event: Dict[str, Any]) -> Dict[str, Any]:
    """Return body as dict, whether provided raw or already parsed."""
    body_raw = event.get("body", "")
    if not body_raw:
        return event  # direct-invoke path (e.g., local test)
    try:
        return json.loads(body_raw)
    except json.JSONDecodeError as exc:
        raise ValueError("Invalid JSON payload") from exc


def lambda_handler(event: Dict[str, Any], _context):
    # ---------- validate / parse incoming request ----------
    try:
        body = _parse_body(event)
    except ValueError as err:
        return {"statusCode": 400, "body": json.dumps({"error": str(err)})}

    base_conf = Config.from_env()
    overrides: Dict[str, Any] = {}

    if "employee_id" in body:
        overrides["employee_id"] = int(body["employee_id"])
    if "admin_mode" in body:
        overrides["admin_mode"] = str(body["admin_mode"]).lower() == "true"
    if "jwt_token" in body:
        if not isinstance(body["jwt_token"], str):
            return {"statusCode": 400,
                    "body": json.dumps({"error": "jwt_token must be a string"})}
        overrides["jwt_token"] = body["jwt_token"]

    config = base_conf.override(**overrides)

    user_prompt = body.get("user_prompt", "").strip()
    if not user_prompt:
        return {"statusCode": 400,
                "body": json.dumps({"error": "user_prompt is required"})}

    # ---------- initial system + user messages -------------
    now = datetime.now()
    messages = [
        {
            "role": "developer",
            "content": (
                "You are an AI assistant on a shift-management platform. "
                f"You are limited to {config.max_tokens} tokens in your response."
                f"current date and time: {now}"
            ),
        },
        {"role": "user", "content": user_prompt},
    ]

    client = OpenAI(api_key=config.openai_api_key)
    tools_schema = select_tools(config)

    # ---------- 1st pass: allow function calls -------------
    logger.info("Sending messages to OpenAI (1st pass)")
    first = client.responses.create(
        model="gpt-3.5-turbo",
        input=messages,
        tools=tools_schema,
    )
    logger.info("OpenAI first response: %s", first)

    # We will collect *only* the tool-output messages here
    new_messages: list[Dict[str, Any]] = []

    for tool_call in first.output:
        if tool_call.type != "function_call":
            continue

        func_name = tool_call.name
        func_args = json.loads(tool_call.arguments)
        logger.info("Executing: %s(%s)", func_name, func_args)

        result = call_function(config, func_name, func_args)
        logger.info("Function result: %s", result)

        # Build the output message for the model
        new_messages.append({
            "type": "function_call_output",
            "call_id": tool_call.call_id,
            "output": json.dumps(result),
        })

    # ---------- 2nd pass: final assistant reply ------------
    logger.info("Sending messages to OpenAI (2nd pass)")
    final = client.responses.create(
        model="gpt-3.5-turbo",
        previous_response_id=first.id,  # replays full history
        input=new_messages,             # ONLY the new tool-output
    )
    logger.info("OpenAI final response: %s", final)

    return {
        "statusCode": 200,
        "body": json.dumps({"ai_reply": final.output_text}),
    }
