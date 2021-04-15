FROM golang:1.16.3

# make sure that following steps are not cached;
# mostly for local testing, not for GitHub Actions
ARG CACHEBUST=1
RUN echo "$CACHEBUST"

RUN git clone https://go.googlesource.com/go /usr/local/golang-tip

ARG GO_BRANCH
RUN test -n "$GO_BRANCH"

RUN cd /usr/local/golang-tip && \
    git reset --hard && \
    git clean -xdf && \
    git remote prune origin && \
    git checkout "$GO_BRANCH" && \
    git pull

ENV GOLANG_VERSION=tip
ENV GOROOT_FINAL=/usr/local/golang-tip
# RUN cd /usr/local/golang-tip/src && ./all.bash
# TODO https://github.com/AlekSi/golang-tip/issues/3
RUN cd /usr/local/golang-tip/src && ./make.bash

RUN cd / && \
    rm -fr /usr/local/go && \
    rm -fr /tmp/golang-tip/.git && \
    ln -s /usr/local/golang-tip /usr/local/go && \
    go version

# to save time to users
RUN go install -v -race std && \
    go install -v std && \
    go clean -cache

LABEL org.opencontainers.image.title="Daily builds of active Go development branches"
LABEL org.opencontainers.image.url=https://github.com/AlekSi/golang-tip
LABEL org.opencontainers.image.source=https://github.com/AlekSi/golang-tip
