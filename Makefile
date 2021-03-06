AUTOGOPATH := $(shell pwd)/vendor:$(shell rm -fr .gopath && mkdir -p .gopath/src/github.com/containers && ln -s ../../../.. .gopath/src/github.com/containers/buildah && cd .gopath && pwd):$(shell rm -fr .govendorpath && mkdir -p .govendorpath && ln -s ../vendor .govendorpath/src && cd .govendorpath && pwd)
AUTOTAGS := $(shell ./btrfs_tag.sh) $(shell ./libdm_tag.sh)

all: buildah

buildah: cmd/buildah/*.go
	env GOPATH=$(AUTOGOPATH) go build -o buildah -tags "$(AUTOTAGS) $(TAGS)" ./cmd/buildah

.PHONY: clean
clean:
	$(RM) buildah

# Some tools don't take well to the GOPATH shenanigans we use to make sure that
# builds succeed.  For those, the checkout directory must be such that out top
# level is at $GOPATH/src/github.com/containers/buildah.
.PHONY: gopath
gopath:
	test $(shell pwd) = $(shell cd ../../../../src/github.com/containers/buildah ; pwd)

# We use https://github.com/lk4d4/vndr to manage dependencies.
.PHONY: deps
deps: gopath
	env GOPATH=$(shell cd ../../../.. ; pwd) vndr
