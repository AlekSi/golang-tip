FROM golang:1.16.3

WORKDIR /usr/local
RUN git clone https://go.googlesource.com/go go-tip
WORKDIR /usr/local/go-tip/src
ENV GOROOT_FINAL=/usr/local/go

# make sure that following steps are not cached;
# mostly for local testing, not for GitHub Actions
ARG CACHEBUST=1
RUN echo "$CACHEBUST"

ARG GO_BRANCH
RUN test -n "$GO_BRANCH"

RUN git remote prune origin
RUN git checkout "$GO_BRANCH"
RUN git pull

# TODO run tests when they are fixed
# RUN ./all.bash
RUN ./make.bash

RUN rm -fr /usr/local/go
RUN mv /usr/local/go-tip /usr/local/go
RUN go version

# to save time to users
RUN go install -v -race std
RUN go install -v std
RUN go clean -cache

LABEL org.opencontainers.image.title="Active Go development branches autobuilds"
LABEL org.opencontainers.image.url=https://github.com/AlekSi/golang-tip
LABEL org.opencontainers.image.source=https://github.com/AlekSi/golang-tip
ENV GOLANG_VERSION=tip
WORKDIR /go
