# syntax=docker/dockerfile:1

ARG GO_BRANCH


FROM --platform=$BUILDPLATFORM golang:1.23.4 AS prepare

RUN git clone https://go.googlesource.com/go /tmp/golang-tip


FROM golang:1.23.4

ARG GO_BRANCH

ENV GOLANG_VERSION=${GO_BRANCH}

COPY --from=prepare /tmp/golang-tip /tmp/golang-tip

RUN <<EOF
set -ex

test -n "$GOLANG_VERSION"

cd /tmp/golang-tip
git reset --hard
git clean -xdf
git remote prune origin
git checkout "$GOLANG_VERSION"
git pull

# RUN cd /tmp/golang-tip/src && env GOROOT_FINAL=/usr/local/go ./all.bash
# TODO https://github.com/AlekSi/golang-tip/issues/3
cd /tmp/golang-tip/src
env GOROOT_FINAL=/usr/local/go ./make.bash

cd /
rm -fr /usr/local/go
rm -fr /tmp/golang-tip/.git
mv /tmp/golang-tip /usr/local/go
go version

# to save time to users
go clean -cache
go install -race std
go install std

EOF

LABEL org.opencontainers.image.description="Daily builds of active Go development branches (branch ${GO_BRANCH})"
LABEL org.opencontainers.image.url=https://github.com/AlekSi/golang-tip
LABEL org.opencontainers.image.source=https://github.com/AlekSi/golang-tip
