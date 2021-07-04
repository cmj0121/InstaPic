#! /usr/bin/env python
from contextlib import contextmanager
from flask_sqlalchemy import SQLAlchemy, current_app


DB = SQLAlchemy()


@contextmanager
def atomic():
    ''' syntax-sugar for safe commit '''
    try:
        yield DB.session
        DB.session.commit()
    except Exception as e:
        current_app.logger.warning(f'DB commit: {e}')
        DB.session.rollback()
        raise

# vim: set ts=4 sw=4 expandtab:
