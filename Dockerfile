FROM python:3.9.6-alpine3.14

RUN apk add --no-cache git bash curl rsync make gcc g++ musl-dev

# ref: https://github.com/flutter/flutter/issues/73260
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk
RUN apk add glibc-2.33-r0.apk
# setup the flutter necessary binary
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /src
ADD . .

RUN pip install -r backend/requirements.txt
RUN make heroku

WORKDIR release
USER nobody

CMD gunicorn main:app -b '0.0.0.0:8000'
