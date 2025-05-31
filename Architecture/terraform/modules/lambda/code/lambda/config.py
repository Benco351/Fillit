from __future__ import annotations
from dataclasses import dataclass, replace
import os
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


@dataclass(frozen=True, slots=True)
class Config:
    """Immutable run-time configuration."""
    openai_api_key: str
    max_tokens: int
    base_url: str
    admin_mode: bool
    employee_id: int
    jwt_token: str = ""

    # ---------- factory helpers ----------
    @classmethod
    def from_env(cls) -> "Config":
        """Build from Lambda environment variables only."""
        return cls(
            openai_api_key=os.getenv("OPEN_AI_API_KEY", ""),
            max_tokens=int(os.getenv("MAX_TOKENS", 100)),
            base_url=os.getenv("BASE_URL", ""),
            admin_mode=os.getenv("ADMIN_MODE", "false").lower() == "true",
            employee_id=int(os.getenv("EMPLOYEE_ID", 0)),
        )

    def override(self, **kwargs) -> "Config":
        """Return a new Config with selected fields replaced."""
        return replace(self, **kwargs)
