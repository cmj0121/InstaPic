FROM python:3.9.6-alpine3.14

WORKDIR /src
ADD . .

RUN pip install -r requirements.txt
USER nobody

CMD uvicorn main:app --reload --host 0.0.0.0
