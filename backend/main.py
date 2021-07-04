#! /usr/bin/env python
from src import create_flask_app

app = create_flask_app()

if __name__ == '__main__':
    app.run(debug=True)

# vim: set ts=4 sw=4 expandtab:
