#! /usr/bin/env python
from flask import request

from . import API, Response, auth_required
from ..models import Post
from ..database import atomic


@API.route('/api/posts')
@auth_required
def list_all_posts():
    '''
        List all the posts (support paginatino)
        ---
        definitions:
          Post:
            type: object
            properties:
              desc:
                type: string
                description: the description of the post
        tags:
          - post
        parameters:
          - in: header
            name: Authorizer
            required: true
            description: the login session
          - in: path
            name: username
            description: filter the posts with specified username
        responses:
          200:
            description: success list the posts
            schema:
              type: array
              items:
                $ref: '#/definitions/Post'
          400:
            description: invalid parameter
          401:
            description: missing header or invalid header
    '''
    username = request.args.get('username')

    sql = Post.query
    if username:
        sql = sql.filter(
            Post.username == username
        )
    return Response.pagination(Post, sql)


@API.route('/api/post', methods=['POST'])
@auth_required
def submit_post():
    '''
        submit a new posts
        ---
        tags:
          - post
        parameters:
          - in: header
            name: Authorizer
            required: true
            description: the login session
          - in: body
            name: desc
            description: the description of the post
        responses:
          201:
            description: success submit a new post
            schema:
              $ref: '#/definitions/Post'
          400:
            description: invalid parameter
          401:
            description: missing header or invalid header
    '''
    if request.json:
        desc = request.json.get('desc', '')

        with atomic() as session:
            post = Post(
                desc=desc,
                user_id=request.user.username,
            )
            session.add(post)
        return Response.created(post)

    return Response.bad_request()

# vim: set ts=4 sw=4 expandtab:
