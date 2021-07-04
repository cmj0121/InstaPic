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

# vim: set ts=4 sw=4 expandtab:
