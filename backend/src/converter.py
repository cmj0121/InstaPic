#! /usr/bin/env python
from flask import json


class JSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if hasattr(obj, '__json__'):
            return obj.__json__() if callable(obj.__json__) else obj.__json__

        return json.JSONEncoder(self, obj)

# vim: set ts=4 sw=4 expandtab:
