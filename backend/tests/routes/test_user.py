#! /usr/bin/env python


def test_user_signup_and_signin(test_client):
    username = 'username'
    password = 'password'

    resp = test_client.post(
        'api/user',
        json={
            'username': username,
            'password': password,
        }
    )
    assert resp.status_code == 201
    assert 'session' in resp.json

    resp = test_client.post(
        'api/user',
        json={
            'username': username,
            'password': password,
        }
    )
    assert resp.status_code == 409

    resp = test_client.post(
        'api/user/signin',
        json={
            'username': username,
            'password': password,
        }
    )
    assert resp.status_code == 201
    assert 'session' in resp.json
    session = resp.json['session']

    resp = test_client.get(
        'api/me',
        headers={
            'Authorizer': session,
        }
    )
    assert resp.status_code == 200
    assert 'username' in resp.json
    assert username == resp.json['username']

    resp = test_client.get(
        'api/me',
    )
    assert resp.status_code == 401

    resp = test_client.get(
        'api/me',
        headers={
            'Authorizer': 'XXXXXXX',
        }
    )
    assert resp.status_code == 401

# vim: set ts=4 sw=4 expandtab:
