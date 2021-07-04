#! /usr/bin/env python
import ulid
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

    @property
    def __json__(self):
        return {
            'username': self.username,
        }

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

    @staticmethod
    def get_login_user(session):
        sql = DB.session.query(User).join(
            UserLoginHistory,
        ).filter(
            UserLoginHistory.session == session,
        )
        return sql.first()


class Post(TimestampMixin, DB.Model):
    __tablename__ = 'post'

    id = DB.Column(DB.String(NAME_LEN), primary_key=True)
    desc = DB.Column(DB.String(TEXT_LEN, convert_unicode=True))
    user_id = DB.Column(DB.String(NAME_LEN), DB.ForeignKey('user.username'), nullable=False, index=True)

    def __init__(self, **kwargs):
        self.id = ulid.ulid()
        super().__init__(**kwargs)

    @property
    def __json__(self):
        return {
            'link': 'https://dummyimage.com/250/ffffff/000000',
            'desc': self.desc or '',
            'username': self.user_id,
        }

# vim: set ts=4 sw=4 expandtab:
