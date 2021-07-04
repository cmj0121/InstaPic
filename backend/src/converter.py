#! /usr/bin/env python
from flask import json


class JSONEncoder(json.JSONEncoder):
    def default(self, obj):
        return json.JSONEncoder(self, obj)

# vim: set ts=4 sw=4 expandtab:
