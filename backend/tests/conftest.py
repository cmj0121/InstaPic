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


@pytest.fixture
def auth_header(app, test_client):
    username = 'mock_usr'
    password = 'mock-pwd'

    resp = test_client.post(
        'api/user/signin',
        json={
            'username': username,
            'password': password,
        }
    )
    if resp.status_code == 201:
        yield {'Authorizer': resp.json['session']}
    elif resp.status_code == 403:
        resp = test_client.post(
            'api/user',
            json={
                'username': username,
                'password': password,
            }
        )
        assert resp.status_code == 201
        yield {'Authorizer': resp.json['session']}
    else:
        raise SystemError('cannot get auth header')

# vim: set ts=4 sw=4 expandtab:
