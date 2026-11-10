"""Shared MySQL connection helper for the scripts in this folder."""

import os
from pathlib import Path

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL, Engine

PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")


def get_engine() -> Engine:
    """Engine for the source MySQL database, configured from .env."""
    url = URL.create(
        drivername="mysql+pymysql",
        username=os.environ["MYSQL_APP_USER"],
        password=os.environ["MYSQL_APP_PASSWORD"],
        host=os.getenv("MYSQL_HOST", "127.0.0.1"),
        port=int(os.getenv("MYSQL_PORT", "3307")),
        database=os.getenv("MYSQL_DATABASE", "olist"),
        query={"charset": "utf8mb4"},
    )
    return create_engine(url, pool_pre_ping=True)
