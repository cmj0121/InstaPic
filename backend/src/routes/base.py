#! /usr/bin/env python
from flask import send_from_directory, current_app

from . import API


@API.route('/healthz')
def health():
    '''
        The health check API
        ---
        responses:
          200:
            description: return empty string
    '''
    return ''


@API.route('/')
def index():
    ''' syntax sugar for service frontend path '''
    return send_from_directory(current_app.config['STATIC_FOLDER'], 'index.html')


@API.route('/<path:path>')
def serve_static_file(path):
    ''' syntax sugar for service frontend path '''
    return send_from_directory(current_app.config['STATIC_FOLDER'], path)

# vim: set ts=4 sw=4 expandtab:
