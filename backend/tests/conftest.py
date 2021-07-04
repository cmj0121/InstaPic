#! /usr/bin/env python
import pytest
from src import create_flask_app


@pytest.fixture
def app():
    app = create_flask_app()
    yield app


@pytest.fixture
def test_client(app):
    with app.app_context():
        with app.test_client() as client:
            yield client

# vim: set ts=4 sw=4 expandtab:
