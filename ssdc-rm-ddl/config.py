import os


class Config:
    DB_USERNAME = os.getenv('DB_USERNAME', 'appuser')
    DB_PASSWORD = os.getenv('DB_PASSWORD', 'postgres')
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = os.getenv('DB_PORT', '6432')
    DB_NAME = os.getenv('DB_NAME', 'rm')
    DB_USESSL = os.getenv('DB_USESSL', '')
