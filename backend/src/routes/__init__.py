#! /usr/bin/env python
from functools import wraps
from flask import Blueprint, jsonify, request


def register_routes(flask_app):
    ''' register API from blueprint '''
    flask_app.register_blueprint(API, url_prefix='/')


class Response(object):
    @staticmethod
    def ok(obj, headers=None):
        response = jsonify(obj)
        if headers and isinstance(headers, dict):
            for key, value in headers.items():
                response.headers[key] = value
        return response, 200

    @staticmethod
    def created(obj, headers=None):
        response = jsonify(obj)
        if headers and isinstance(headers, dict):
            for key, value in headers.items():
                response.headers[key] = value
        return response, 201

    @staticmethod
    def bad_request(message=None):
        response = jsonify({
            'message': message or 'Bad Request',
        })
        return response, 400

    @staticmethod
    def unauthorized(message=None):
        response = jsonify({
            'message': message or 'Unauthorized',
        })
        return response, 401

    @staticmethod
    def forbidden(message=None):
        response = jsonify({
            'message': message or 'Forbidden',
        })
        return response, 403

    @staticmethod
    def conflict(message=None):
        response = jsonify({
            'message': message or 'Conflict',
        })
        return response, 409


def auth_required(fn):
    @wraps(fn)
    def inner_auth_required(*args, **kwargs):
        from ..models import UserLoginHistory

        session = request.headers.get('Authorizer')
        user = UserLoginHistory.get_login_user(session)  # noqa
        if not user:
            return Response.unauthorized()

        request.user = user
        return fn(*args, **kwargs)

    return inner_auth_required


API = Blueprint('api', __name__)

from . import base  # noqa
from . import user  # noqa
from . import post  # noqa

# vim: set ts=4 sw=4 expandtab:
