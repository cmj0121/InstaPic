#! /usr/bin/env python


def test_post(test_client, auth_header):
    resp = test_client.get('api/posts')
    assert resp.status_code == 401

    resp = test_client.get(
        'api/posts',
        headers=auth_header,
    )
    assert resp.status_code == 200
    assert isinstance(resp.json, list)
    assert len(resp.json) == 0

    # wrong pagination parameters
    resp = test_client.get(
        'api/posts?page_size=a',
        headers=auth_header,
    )
    assert resp.status_code == 400

    resp = test_client.get(
        'api/posts?page_size=-2',
        headers=auth_header,
    )
    assert resp.status_code == 400

    resp = test_client.get(
        'api/posts?page_size=1000',
        headers=auth_header,
    )
    assert resp.status_code == 400

    # test submit photo
    for n in range(1, 20):
        resp = test_client.post(
            'api/post',
            json={
                'desc': f'memo - {n}',
            },
            headers=auth_header,
        )
        assert resp.status_code == 201
        assert resp.json['desc'] == f'memo - {n}'

        resp = test_client.get(
            'api/posts',
            headers=auth_header,
        )
        assert resp.status_code == 200
        assert isinstance(resp.json, list)
        assert len(resp.json) == n

        resp = test_client.get(
            'api/posts?page_size=4',
            headers=auth_header,
        )
        assert resp.status_code == 200
        assert isinstance(resp.json, list)
        assert len(resp.json) == min(n, 4)
        if n > 4:
            assert 'NEXT_ID' in resp.headers

# vim: set ts=4 sw=4 expandtab:
