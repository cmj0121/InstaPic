#! /usr/bin/env python
from . import API, Response


@API.route('/api/posts')
def list_all_posts():
    return Response.ok([])


@API.route('/api/post', methods=['POST'])
def submit_post():
    return Response.created()

# vim: set ts=4 sw=4 expandtab:
