#! /usr/bin/env python
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()


@app.get('/healthz', response_class=HTMLResponse)
def healthz():
	return ''

#! vim: set ts=4 sw=4 expandtab:
