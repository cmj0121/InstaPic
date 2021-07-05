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
command `make start` to setup everything well.

## Swagger ##
For the external developer, this project provides [OpenAPI][3] to expose the public APIs.
More detail can see the path */apidocs* or the public service [link][4]

[0]: https://dashboard.heroku.com/
[1]: https://true-backbacon-32727.herokuapp.com/
[2]: https://docs.docker.com/compose/
[3]: https://swagger.io/specification/
[4]: https://true-backbacon-32727.herokuapp.com/apidocs

