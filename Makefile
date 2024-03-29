NAME = raiscui/mybase
VERSION = 1

.PHONY: all build test tag_latest release ssh

all: build tag

build:
	docker build -t $(NAME):$(VERSION) --rm .

test:
	echo "no test"

tag:
	docker tag $(NAME):$(VERSION) $(NAME):latest

pub: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"
