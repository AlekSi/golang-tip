FROM golang:1.16.3

RUN git clone https://go.googlesource.com/go /usr/local/golang-tip

# make sure that following steps are not cached;
# mostly for local testing, not for GitHub Actions
ARG CACHEBUST=1
RUN echo "$CACHEBUST"

ARG GO_BRANCH
RUN test -n "$GO_BRANCH"

RUN cd /usr/local/golang-tip && \
    git reset --hard && \
    git clean -xdf && \
    git remote prune origin && \
    git checkout "$GO_BRANCH" && \
    git pull

ENV GOLANG_VERSION=tip
ENV GOROOT_FINAL=/usr/local/go
# RUN cd /usr/local/golang-tip/src && ./all.bash TODO run tests when they are fixed
RUN cd /usr/local/golang-tip/src && ./make.bash

RUN cd / && \
    rm -fr /usr/local/go && \
    mv /usr/local/golang-tip /usr/local/go && \
    go version

# to save time to users
RUN go install -v -race std && \
    go install -v std && \
    go clean -cache

LABEL org.opencontainers.image.title="Daily builds of active Go development branches"
LABEL org.opencontainers.image.url=https://github.com/AlekSi/golang-tip
LABEL org.opencontainers.image.source=https://github.com/AlekSi/golang-tip
