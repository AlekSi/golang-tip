all: build

up:
	docker buildx create --driver docker-container --name golang-tip

down:
	docker buildx rm golang-tip

build:
	docker buildx build \
		--builder golang-tip \
		--output type=docker \
		--tag golang-tip:$(GO_BRANCH) \
		--build-arg GO_BRANCH=$(GO_BRANCH) \
		--build-arg CACHEBUST=$(shell date +%s) \
		.

	docker tag golang-tip:$(GO_BRANCH) aleksi/golang-tip:$(GO_BRANCH)
	docker tag golang-tip:$(GO_BRANCH) ghcr.io/aleksi/golang-tip:$(GO_BRANCH)
	docker rmi golang-tip:$(GO_BRANCH)

push:
	docker push aleksi/golang-tip:$(GO_BRANCH)
	docker push ghcr.io/aleksi/golang-tip:$(GO_BRANCH)
