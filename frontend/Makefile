SRC=$(wildcard lib/*.dart) $(wildcard web/**)
BUILD=build/web

.PHONY: all clean help

all:	# setup basic environment

clean:	# cleanup temporary file and environment
	find . -name '*.swp' -delete

help:	# show this message
	@printf "Usage: make [OPTION]\n"
	@printf "\n"
	@perl -nle 'print $$& if m{^[\w-]+:.*?#.*$$}' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?#"} {printf "    %-18s %s\n", $$1, $$2}'

build: $(BUILD)		# build all service

run: $(BUILD)		# run on local environment
	python3 -m http.server -d $(BUILD)

$(BUILD): $(SRC)
	flutter build web
