VENV=.venv

.PHONY: all clean help

all: $(VENV)	# setup basic environment

clean:			# cleanup temporary file and environment
	@find . -name '*.swp' -delete
	@rm -rf $(VENV)

help:	# show this message
	@printf "Usage: make [OPTION]\n"
	@printf "\n"
	@perl -nle 'print $$& if m{^[\w-]+:.*?#.*$$}' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?#"} {printf "    %-18s %s\n", $$1, $$2}'

$(VENV):
	python3 -m venv $@

route:	# show all routes
	FLASK_APP=main:app flask routes

test:	# run test
	python -m pytest
