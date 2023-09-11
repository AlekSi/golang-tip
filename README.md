# golang-tip

[![Build](https://github.com/AlekSi/golang-tip/actions/workflows/build.yml/badge.svg?branch=main&event=schedule)](https://github.com/AlekSi/golang-tip/actions/workflows/build.yml)
[![Go Report Card](https://goreportcard.com/badge/github.com/AlekSi/golang-tip)](https://goreportcard.com/report/github.com/AlekSi/golang-tip)

Daily builds of [active Go development branches](https://github.com/golang/go/branches/active).
Available as:
* Docker images (based on [Go "Official Image"](https://github.com/docker-library/golang))
on both [Docker Hub](https://hub.docker.com/r/aleksi/golang-tip)
and [GitHub Container Registry](https://github.com/users/AlekSi/packages/container/package/golang-tip)
* [.tar.gz files](https://github.com/AlekSi/golang-tip/releases/tag/tip)

They may be used on CI/CD to avoid rebuilding Go from the source code every time, saving time and resources. They may also be used for local development.


# Quickstart

Examples for `master` / tip branch:

```sh
docker pull aleksi/golang-tip:master
# or
docker pull ghcr.io/aleksi/golang-tip:master

# then use it as an official Go Docker image
```

```sh
# for Linux
curl -o master.tmp.tar.gz -L https://github.com/AlekSi/golang-tip/releases/download/tip/master.linux-amd64.tmp.tar.gz

# for macOS
curl -o master.tmp.tar.gz -L https://github.com/AlekSi/golang-tip/releases/download/tip/master.darwin-amd64.tmp.tar.gz

# for both
rm -rf /tmp/golang-tip && tar -C /tmp -xzf master.tmp.tar.gz
/tmp/golang-tip/bin/go env
```

## Using golang-tip in GitHub Actions

Examples for using golang-tip in a GitHub Action.

### .tar.gz

> This example shows how to use golang-tip's .tar.gz release format
within a GitHub Actions runner. We first purge an existing Go installation.
If you are looking to save on Actions minutes, this workflow takes
less than half the time to run as the container example below.

```yaml
# Remove existing Go installation, install golang-tip from latest .tar.gz
# More .tar.gz releases can be found here: https://github.com/AlekSi/golang-tip/releases/tag/tip

# action.yml
---
name: Go unit tests with golang-tip
on:
  pull_request:
jobs:
  test-my-app-targz:
    name: test my golang app using golang-tip .tar.gz release
    runs-on: ubuntu-latest
    steps:
      - name: Remove existing go installation from Actions runner
        run: |
          sudo rm -fr /opt/hostedtoolcache/go /usr/local/go /usr/bin/go /bin/go
      - name: Install latest golang-tip on Actions runner
        run: |
          curl -o go.tar.gz -L \
            https://github.com/AlekSi/golang-tip/releases/download/tip/master.linux-amd64.tar.gz
          sudo tar -C /usr/local -xzf go.tar.gz
          sudo ln -s /usr/local/go/bin/* /usr/local/bin/
      - uses: actions/checkout@v2
      - name: run tests
        run: go test ./...
```

### Container image

> This example shows how you can use golang-tip's prebuilt container image
directly within your GitHub Action Workflow. All `steps` are executed within
the container image at `ghcr.io/aleksi/golang-tip:master` for the `test-my-app`
Job.

```yaml
# Run your Job within latest golang-tip built container.
# Use head of golang-tip aka "master" or other available image tags here:
# https://github.com/AlekSi/golang-tip/pkgs/container/golang-tip

# action.yml
---
name: Go unit tests with golang-tip
on:
  pull_request:
jobs:
  test-my-app-oci:
    name: test my golang app using golang-tip container release
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/aleksi/golang-tip:master
    steps:
      - uses: actions/checkout@v2
      - name: run tests
        run: go test ./...
```

# Branches

Currently built branches (see [here](https://github.com/AlekSi/golang-tip/blob/main/.github/workflows/build.yml)):
* `master` a.k.a tip, the next Go version.


# Docker

Docker images are based on the latest stable Go image. The development version completely replaces stable Go in `/usr/local/go`.
`GOLANG_VERSION` environment variable is set to the branch name.

```dockerfile
FROM aleksi/golang-tip:master
```

or

```dockerfile
FROM ghcr.io/aleksi/golang-tip:master
```


# .tar.gz

`.tar.gz` files are provided in two variants. The main one behaves like [the official Go release](https://golang.org/doc/install) -
it is expected to be unpacked into `/usr/local` as `/usr/local/go`:

```sh
rm -rf /usr/local/go && tar -C /usr/local -xzf master.linux-amd64.tar.gz
```

The variant with `.tmp` in the file name is expected to be unpacked into `/tmp` as `/tmp/golang-tip` (that's the value of [GOROOT_FINAL](https://golang.org/doc/install/source#environment) set during compilation):

```sh
rm -rf /tmp/golang-tip && tar -C /tmp -xzf master.linux-amd64.tmp.tar.gz
```

That allows that version to co-exist with other versions of Go and be installed without additional privileges.


# Credits

Made by Alexey Palazhchenko.

Inspired by [go-tip by Craig Peterson](https://github.com/captncraig/go-tip).


# Contributing

Pull requests that add other branches, base Docker images, OSes, and CPU architectures are welcome.
