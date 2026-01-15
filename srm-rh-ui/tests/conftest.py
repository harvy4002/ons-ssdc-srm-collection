import pytest
from rh_ui.app_setup import create_app


@pytest.fixture
def app():
    app = create_app()
    return app


@pytest.fixture
def test_client(app):
    test_client = app.test_client()
    with app.app_context():
        yield test_client
