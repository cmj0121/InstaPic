.PHONY: all clean help

all:	# setup basic environment

clean:	# cleanup temporary file and environment
	find . -name '*.swp' -delete

help:	# show this message
	@printf "Usage: make [OPTION]\n"
	@printf "\n"
	@perl -nle 'print $$& if m{^[\w-]+:.*?#.*$$}' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?#"} {printf "    %-18s %s\n", $$1, $$2}'

run:		# run everything on the local environment
	docker-compose up --build -d

stop:		# stop all services in local environment
	docker-compose stop

rebuild:	# force rebuild the local environment
	docker-compose stop
	docker-compose rm -f
	docker-compose up --build -d

log:		# show the log for local environment
	docker-compose logs -f
