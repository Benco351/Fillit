from __future__ import annotations
import requests
import re
from typing import Any, Dict, List

from config import Config


def _auth_header(config: Config) -> Dict[str, str]:
    token = (config.jwt_token or "").strip()
    if token:
        return {"Authorization": f"Bearer {token}"}
    return {}


def get_assigned_shifts(config: Config, assigned_employee_id: int | None = None) -> List[Dict[str, Any]]:
    params: Dict[str, Any] = {}

    if not config.admin_mode:
        params["assigned_employee_id"] = config.employee_id

    if assigned_employee_id is not None and assigned_employee_id != -1:
        params["assigned_employee_id"] = assigned_employee_id

    try:
        resp = requests.get(f"{config.base_url}/api/assigned-shifts",
                            params=params, headers=_auth_header(config))
        resp.raise_for_status()
        return resp.json().get("data", [])
    except requests.RequestException as exc:
        return [{"status": "error", "message": str(exc)}]


def get_requested_shifts(config: Config,
                         request_status: str | None = None,
                         request_employee_id: int | None = None) -> List[Dict[str, Any]]:
    params: Dict[str, Any] = {}

    if not config.admin_mode:
        params["request_employee_id"] = config.employee_id

    if request_status and request_status != "all":
        params["request_status"] = request_status

    if request_employee_id is not None and request_employee_id != -1:
        params["request_employee_id"] = request_employee_id

    try:
        resp = requests.get(f"{config.base_url}/api/requested-shifts",
                            params=params, headers=_auth_header(config))
        resp.raise_for_status()
        return resp.json().get("data", [])
    except requests.RequestException as exc:
        return [{"status": "error", "message": str(exc)}]


def get_available_shifts(
    config: Config,
    shift_date: str | None = None,
    shift_start_date: str | None = None,
    shift_end_date: str | None = None,
    shift_start_before: str | None = None,
    shift_start_after: str | None = None,
    shift_end_before: str | None = None,
    shift_end_after: str | None = None,
    shift_slots_amount: int | None = None,
    shift_slots_taken: int | None = None,
) -> List[Dict[str, Any]]:
    """Return available shifts, optionally filtered by date, time, or slot counts."""
    date_re = re.compile(r"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$")
    time_re = re.compile(r"^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d$")

    def _clean(v): return None if (v is None or v == "all") else v

    def ok_date(v: str | None) -> bool:  # YYYY-MM-DD
        return bool(v and date_re.fullmatch(v))

    def ok_time(v: str | None) -> bool:  # HH:MM:SS
        return bool(v and time_re.fullmatch(v))

    # Collect raw inputs, treating the literal "all" as no-filter (None)
    raw_params: Dict[str, Any] = {
        "shift_date":             None if shift_date == "all" else shift_date,
        "shift_start_date":       None if shift_start_date == "all" else shift_start_date,
        "shift_end_date":         None if shift_end_date == "all" else shift_end_date,
        "shift_start_before":     None if shift_start_before == "all" else shift_start_before,
        "shift_start_after":      None if shift_start_after == "all" else shift_start_after,
        "shift_end_before":       None if shift_end_before == "all" else shift_end_before,
        "shift_end_after":        None if shift_end_after == "all" else shift_end_after,
        "shift_slots_amount": _clean(shift_slots_amount),
        "shift_slots_taken":  _clean(shift_slots_taken),
    }

    # Build the query dict, validating each value
    params: Dict[str, Any] = {}
    for k, v in raw_params.items():
        if v is None:
            continue
        if "date" in k and ok_date(v):
            params[k] = v
        elif any(tag in k for tag in ("before", "after")) and ok_time(v):
            params[k] = v
        elif k.startswith("shift_slots") and isinstance(v, int) and v > 0:   # ← only >0
            params[k] = v

    # Call the backend even if no filters were supplied (returns all shifts)
    try:
        resp = requests.get(
            f"{config.base_url}/api/available-shifts",
            params=params or None,      # None → no “?”
            headers=_auth_header(config),
            timeout=10,
        )
        resp.raise_for_status()
        return resp.json().get("data", [])
    except requests.RequestException as exc:
        return [{"status": "error", "message": str(exc)}]
