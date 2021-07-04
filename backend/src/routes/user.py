#! /usr/bin/env python
import time
import random
from flask import request, current_app

from . import API, Response, auth_required
from ..models import User


@API.route('/api/me')
@auth_required
def me():
    '''
        get user info
        ---
        tags:
          - user
        parameters:
          - in: header
            name: Authorizer
            required: true
            description: the login session
        responses:
          200:
            description: success sign-up
            schema:
              type: object
              properties:
                username:
                  type: string
                  description: the username
          401:
            description: missing header or invalid header
    '''
    return Response.ok(request.user)


@API.route('/api/user', methods=['POST'])
def signup():
    '''
        User sign-up
        ---
        tags:
          - user
        parameters:
          - in: body
            name: body
            schema:
              required:
                - username
                - password
              properties:
                username:
                  type: string
                  example: Carol
                password:
                  type: string
                  example: password
        responses:
          201:
            description: success sign-up
            schema:
              type: object
              properties:
                session:
                  type: string
                  description: the login sesssion, should be stored carefully
          400:
            description: missing any necessary field
          409:
            description: user already sign-up
    '''
    if request.json:
        username = request.json.get('username')
        password = request.json.get('password')

        if username and password:
            try:
                if User.get(username):
                    current_app.logger.warning(f'{username} already exist')
                    time.sleep(random.randint(1, 100) / 100.0)
                    return Response.conflict(username)

                user = User.create_user(username, password)
                return Response.created({
                    'username': username,
                    'session': user.session,
                })
            except Exception as e:
                current_app.logger.info(f'cannot create user: {e}')
                return Response.conflict(username)

    return Response.bad_request()


@API.route('/api/user/signin', methods=['POST'])
def signin():
    '''
        User sign-in
        ---
        tags:
          - user
        parameters:
          - in: body
            name: body
            schema:
              required:
                - username
                - password
              properties:
                username:
                  type: string
                  example: Carol
                password:
                  type: string
                  example: password
        responses:
          201:
            description: success sign-up
            schema:
              type: object
              properties:
                session:
                  type: string
                  description: the login sesssion, should be stored carefully
          400:
            description: missing any necessary field
          403:
            description: invalid username / password
    '''
    if request.json:
        username = request.json.get('username')
        password = request.json.get('password')

        if username and password:
            user = User.get(username)
            if not user or not user.verify(password):
                current_app.logger.warning(f'signin failure on user: {username} ({user})')
                time.sleep(random.randint(1, 100) / 100.0)
                return Response.forbidden()

            return Response.created({
                'username': username,
                'session': user.session,
            })

    return Response.bad_request()

# vim: set ts=4 sw=4 expandtab:
