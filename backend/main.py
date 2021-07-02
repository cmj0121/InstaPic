#! /usr/bin/env python
from fastapi import FastAPI
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles


app = FastAPI()

@app.get('/healthz', response_class=HTMLResponse)
def healthz():
	return ''

@app.get('/')
def index():
    return FileResponse('static/index.html')

# final service the static files
app.mount('/', StaticFiles(directory='static/'), name='static')

#! vim: set ts=4 sw=4 expandtab:
