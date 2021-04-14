GO_BRANCH ?= master

all: docker-build targz-build

docker-up:
	docker buildx create --driver docker-container --name golang-tip

docker-down:
	docker buildx rm golang-tip

docker-build:
	test -n "$(GO_BRANCH)"

	docker buildx build \
		--builder golang-tip \
		--output type=docker \
		--tag golang-tip:$(GO_BRANCH) \
		--build-arg GO_BRANCH=$(GO_BRANCH) \
		--build-arg CACHEBUST=$(shell date +%s) \
		.

# TODO run tests when limits problem is fixed
targz-build:
	test -n "$(GO_BRANCH)"

	rm -fr /tmp/golang-tip /tmp/go
	git clone --branch $(GO_BRANCH) https://go.googlesource.com/go /tmp/golang-tip
	# TODO
	# cd /tmp/golang-tip/src && env GOROOT_FINAL=/usr/local/go ./make.bash
	rm -fr /tmp/golang-tip/.git
	mv /tmp/golang-tip /tmp/go
	tar -czf golang-tip.tar.gz -C /tmp go
	rm -fr /tmp/go
