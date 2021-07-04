#! /usr/bin/env python
import time
import random
from flask import request, current_app

from . import API, Response
from ..models import User


@API.route('/api/user', methods=['POST'])
def signup():
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
                    'session': user.session,
                })
            except Exception as e:
                current_app.logger.info(f'cannot create user: {e}')
                return Response.conflict(username)

    return Response.bad_request()


@API.route('/api/user/signin', methods=['POST'])
def signin():
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
                'session': user.session,
            })

    return Response.bad_request()

# vim: set ts=4 sw=4 expandtab:
