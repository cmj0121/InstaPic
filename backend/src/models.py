#! /usr/bin/env python
import hashlib
import secrets
from datetime import datetime
from sqlalchemy.orm import relationship

from .database import DB, atomic


NAME_LEN = 64
DATA_LEN = 128
TEXT_LEN = 512


class TimestampMixin(object):
    created_at = DB.Column(DB.DateTime, default=datetime.utcnow())
    updated_at = DB.Column(DB.DateTime, onupdate=datetime.utcnow())
    deleted_at = DB.Column(DB.DateTime)


class User(TimestampMixin, DB.Model):
    __tablename__ = 'user'

    username = DB.Column(DB.String(NAME_LEN), primary_key=True)
    password_salt = DB.Column(DB.String(DATA_LEN), nullable=False)
    password_hash = DB.Column(DB.String(DATA_LEN), nullable=False)

    @classmethod
    def get(cls, username):
        sql = DB.session.query(cls).filter(
            cls.username == username,
        )
        return sql.first()

    @classmethod
    def create_user(cls, username, password):
        password_salt = secrets.token_hex(12)
        password_hash = hashlib.sha256(f'{password}{password_salt}'.encode()).hexdigest()

        with atomic() as session:
            if User.get(username):
                raise KeyError(f'duplicate username: {username}')

            user = User(
                username=username,
                password_salt=password_salt,
                password_hash=password_hash,
            )
            session.add(user)
        return user

    def verify(self, password):
        password_hash = hashlib.sha256(f'{password}{self.password_salt}'.encode()).hexdigest()
        return password_hash == self.password_hash

    @property
    def session(self):
        with atomic() as session:
            login_session = UserLoginHistory(
                session=secrets.token_hex(64),
                user_id=self.username,
            )
            session.add(login_session)
        return login_session.session


class UserLoginHistory(TimestampMixin, DB.Model):
    __tablename__ = 'user_login_history'

    session = DB.Column(DB.String(DATA_LEN), primary_key=True)
    user_id = DB.Column(DB.String(NAME_LEN), DB.ForeignKey('user.username'), nullable=False)

    user = relationship('User', uselist=False)

# vim: set ts=4 sw=4 expandtab:
