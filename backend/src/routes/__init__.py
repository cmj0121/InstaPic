#! /usr/bin/env python
from functools import wraps
from flask import Blueprint, jsonify, request, make_response


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
    def blob(blob, filename, headers=None):
        response = make_response(blob)
        if headers and isinstance(headers, dict):
            for key, value in headers.items():
                response.headers[key] = value
        response.headers.set('Content-Type', 'image/png')
        response.headers.set('Content-Disposition', 'attachment', filename=filename)
        return response

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

    @staticmethod
    def pagination(obj, sql, page_size=4, primary_key='id'):
        page_size = request.args.get('page_size', page_size)
        if isinstance(page_size, str) and not page_size.isdigit():
            return Response.bad_request(f'page_size should be int: {page_size}')

        page_size = int(page_size)
        if not 0 < page_size < 100:
            return Response.bad_request(f'page_size should be within 0 ~ 100: {page_size}')

        next_id = request.args.get('next_id')
        if next_id:
            sql = sql.filter(
                getattr(obj, primary_key) < next_id,
            )

        rows = sql.order_by(getattr(obj, primary_key).desc()).limit(page_size+1).all()
        if len(rows) > page_size:
            rows = rows[:-1]
            return Response.ok(rows, {'NEXT_ID': getattr(rows[-1], primary_key)})

        return Response.ok(rows)


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
