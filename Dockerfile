FROM golang:1.21.1

RUN git clone https://go.googlesource.com/go /tmp/golang-tip

# make sure that following steps are not cached;
# mostly for local testing, not for GitHub Actions
ARG CACHEBUST=1
RUN echo "$CACHEBUST"

ARG GO_BRANCH
RUN test -n "$GO_BRANCH"

ENV GOLANG_VERSION=${GO_BRANCH}

RUN cd /tmp/golang-tip && \
    git reset --hard && \
    git clean -xdf && \
    git remote prune origin && \
    git checkout "$GO_BRANCH" && \
    git pull

# RUN cd /tmp/golang-tip/src && env GOROOT_FINAL=/usr/local/go ./all.bash
# TODO https://github.com/AlekSi/golang-tip/issues/3
RUN cd /tmp/golang-tip/src && env GOROOT_FINAL=/usr/local/go ./make.bash

RUN cd / && \
    rm -fr /usr/local/go && \
    rm -fr /tmp/golang-tip/.git && \
    mv -v /tmp/golang-tip /usr/local/go && \
    go version

# to save time to users
RUN go install -v -race std && \
    go install -v std && \
    go clean -cache

LABEL org.opencontainers.image.title="Daily builds of active Go development branches"
LABEL org.opencontainers.image.url=https://github.com/AlekSi/golang-tip
LABEL org.opencontainers.image.source=https://github.com/AlekSi/golang-tip
