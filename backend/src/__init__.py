#! /usr/bin/env python
import os
import logging
from flask import Flask, request
from flasgger import Swagger


def before_request():
    ''' any pre-process pre each request '''
    request.user = None


def create_flask_app(config=None):
    from .converter import JSONEncoder
    from .database import DB
    from .routes import register_routes

    config = config or Config()

    app = Flask(__name__, static_folder=config.STATIC_FOLDER)
    app.json_encoder = JSONEncoder

    # load global config
    app.config.from_object(config)

    gunicorn_logger = logging.getLogger('gunicorn.error')
    app.logger.handlers.extend(gunicorn_logger.handlers)

    # initial flask plugins
    DB.init_app(app)

    # register swagger
    swagger_config = Swagger.DEFAULT_CONFIG
    # enable OpenAPI 3
    swagger_config['swagger_ui_bundle_js'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui-bundle.js'
    swagger_config['swagger_ui_standalone_preset_js'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui-standalone-preset.js'
    swagger_config['jquery_js'] = '//unpkg.com/jquery@2.2.4/dist/jquery.min.js'
    swagger_config['swagger_ui_css'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui.css'
    app.config['SWAGGER'] = {
        'uiversion': 3,
        # NOTE - the 3.0.2 will not workable when setting host and basePath
        # 'openapi': '3.0.2',
    }
    Swagger(app, config=swagger_config)

    # register all API
    register_routes(app)

    # pre-process per each request
    app.before_request(before_request)

    @app.before_first_request
    def before_first_request():
        DB.create_all()

    return app


class Config(object):
    DEBUG = True

    STATIC_FOLDER = f'{os.getcwd()}/static'

    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'
    SQLALCHEMY_TRACK_MODIFICATIONS = True

# vim: set ts=4 sw=4 expandtab:
