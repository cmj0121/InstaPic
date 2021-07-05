# InstaPic #
![CI](https://github.com/cmj0121/InstaPic/workflows/pipeline/badge.svg)

The mock image sharing website for take-home challenge.

## Requirement ##
Implement a website (include frontend and backend) that

- registration by username/password
- submit photo and short text description
- list all uploaded photo
- testing
- [OPTIONAL] sorted by time
- [OPTIONAL] filter by user

## Heroku ##
The test environment is based on the [heroku][0] and test-site is located on [here][1]

## Local Environment ##
You can setup your own environment based on the [docker-compose][2]. It can setup by run
command `make start` to setup everything well, and you can access [service][5] on browser.

## Swagger ##
For the external developer, this project provides [OpenAPI][3] to expose the public APIs.
More detail can see the path */apidocs* or the public service [link][4]

## Source Code Layout ##

	.
	├── Dockerfile
	├── Makefile
	├── docker-compose.yaml
	├── backend/
	└── frontend/

In this project it contains two major folder: *frontend* and *backend*. All the frontend
source codes are located in frontend folder which is basded on the [futter][6], and all
backend related soure codes are located in the backend folder which is based on [Python][7]
and [flask][8].

Without the source code, this project is based on the [make][9] to control code-build,
testing and deploy flow. More detail can run `make help` to list all support commands.

### Local Environment ###
You can setup your local environment by run `make run` which is based on the [docker compose][2].
The *Dockerfile* describes how to build the image and *docker-compose.yaml* describes
the service and test-purpose database which is based on postgre-sql.

### Frontend ###
In the frontend folder it contains the flutter/dart source code. The *frontend/lib/main.dart*
is the entry point of the frontend which build the *InstaPicApp* main widget. Based on the
URL strategy, this application support three routes endpoint: *IndexPage.route*, *LoginPage.route*
and *UploadPage.route*. Each of three routes are mapped to related widget.


### Backend ###
In the backend folder it contains the flask-based source code. The entrypoint of backend
is *main.py* which contains the flask application. The related source codes are all stored
in src/ folder which the exposed endpoint defined in *routes/*.

Also the file *models.py* defines the model of data used in this application which is
based on the [SQLalchemy][10], an python-based ORM framework.

	backend/
	├── Makefile
	├── main.py
	├── requirements.txt
	├── src
	│   └── routes
	└── tests


[0]: https://dashboard.heroku.com/
[1]: https://true-backbacon-32727.herokuapp.com/
[2]: https://docs.docker.com/compose/
[3]: https://swagger.io/specification/
[4]: https://true-backbacon-32727.herokuapp.com/apidocs
[5]: http://localhost:8000
[6]: https://flutter.dev/
[7]: https://www.python.org/
[8]: https://flask.palletsprojects.com/en/2.0.x/
[9]: https://en.wikipedia.org/wiki/Make_(software)
[10]: https://www.sqlalchemy.org/

