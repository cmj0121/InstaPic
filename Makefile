SUBDIR=frontend backend

.PHONY: all clean help $(SUBDIR)

all:	# setup basic environment
	@pre-commit install --install-hooks

clean: $(SUBDIR)	# cleanup temporary file and environment
	@find . -name '*.swp' -delete

help:	# show this message
	@printf "Usage: make [OPTION]\n"
	@printf "\n"
	@perl -nle 'print $$& if m{^[\w-]+:.*?#.*$$}' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?#"} {printf "    %-18s %s\n", $$1, $$2}'

$(SUBDIR):
	$(MAKE) -C $@ $(MAKECMDGOALS)

start:		# run everything on the docker environment
	docker-compose up -d

stop:		# stop all services in docker environment
	docker-compose stop

restart:	# force rebuild the docker environment
	docker-compose stop
	docker-compose rm -f
	docker-compose up --build -d --remove-orphans

log:		# show the log for docker environment
	docker-compose logs -f

heroku:	# build and ready deploy to heroku
	$(MAKE) -C frontend/ build
	rsync -ar --delete --include='*/' --include='*.py' --include=requirements.txt --exclude='*' backend/ release/
	rsync -ar --delete frontend/build/web/ release/static/
