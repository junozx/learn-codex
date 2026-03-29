from __future__ import annotations

from backend_service.config import load_settings


def main() -> None:
    settings = load_settings()
    print(
        "backend_service",
        f"env={settings.app_env}",
        f"listen={settings.app_host}:{settings.app_port}",
        f"mysql={settings.mysql_host}:{settings.mysql_port}/{settings.mysql_database}",
    )


if __name__ == "__main__":
    main()
