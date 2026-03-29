from backend_service.config import Settings


def test_mysql_dsn() -> None:
    settings = Settings(
        app_env="test",
        app_host="127.0.0.1",
        app_port=8000,
        mysql_host="localhost",
        mysql_port=3306,
        mysql_user="user",
        mysql_password="pass",
        mysql_database="demo",
    )
    assert settings.mysql_dsn() == "mysql+pymysql://user:pass@localhost:3306/demo"
