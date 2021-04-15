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

# run tests when limits problem is fixed
# TODO https://github.com/AlekSi/golang-tip/issues/4
targz-build:
	test -n "$(GO_BRANCH)"

	rm -fr /tmp/golang-tip
	git clone --branch $(GO_BRANCH) https://go.googlesource.com/go /tmp/golang-tip
	cd /tmp/golang-tip/src && env GOROOT_FINAL=/usr/local/golang-tip ./make.bash
	rm -fr /tmp/golang-tip/.git
	tar -czf golang-tip.tar.gz -C /tmp golang-tip
	rm -fr /tmp/golang-tip
