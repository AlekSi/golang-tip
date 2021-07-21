# golang-tip

[![Build](https://github.com/AlekSi/golang-tip/actions/workflows/build.yml/badge.svg?branch=main&event=schedule)](https://github.com/AlekSi/golang-tip/actions/workflows/build.yml)

Daily builds of [active Go development branches](https://github.com/golang/go/branches/active).
Available as:
* Docker images (based on [Go "Official Image"](https://github.com/docker-library/golang))
on both [Docker Hub](https://hub.docker.com/r/aleksi/golang-tip)
and [GitHub Container Registry](https://github.com/users/AlekSi/packages/container/package/golang-tip)
* [.tar.gz files](https://github.com/AlekSi/golang-tip/releases/tag/tip)


# Quickstart

Examples for `master` / tip branch:

```sh
docker pull aleksi/golang-tip:master
docker pull ghcr.io/aleksi/golang-tip:master

curl -LO https://github.com/AlekSi/golang-tip/releases/download/tip/master.linux-amd64.tar.gz
curl -LO https://github.com/AlekSi/golang-tip/releases/download/tip/master.darwin-amd64.tar.gz
```


# Branches

Currently built branches (see [here](https://github.com/AlekSi/golang-tip/blob/main/.github/workflows/build.yml)):
* `master` a.k.a tip, the next Go version
* `dev.boringcrypto` – [BoringCrypto](https://github.com/golang/go/blob/dev.boringcrypto/README.boringcrypto.md)
* `dev.fuzz` – [fuzz test support](https://github.com/golang/go/issues/44551)
* `dev.go2go` – [old generics branch](https://github.com/golang/go/blob/dev.go2go/README.go2go.md)
* `dev.typeparams` - generics development during the freeze
* `dev.cmdgo` - [`cmd/go` development during the freeze](https://github.com/golang/go/issues/43084)


# Docker

Docker images are based on the latest stable Go image. The development version completely replaces stable Go in `/usr/local/go`. `GOLANG_VERSION` environment variable is set to the branch name.

```dockerfile
FROM aleksi/golang-tip:master
```

or

```dockerfile
FROM ghcr.io/aleksi/golang-tip:master
```


# .tag.gz

`.tar.gz` files are provided in two variants. The main one behaves like [the official Go release](https://golang.org/doc/install) -
it is expected to be unpacked into `/usr/local` as `/usr/local/go`:

```
rm -rf /usr/local/go && tar -C /usr/local -xzf master.linux-amd64.tar.gz
```

The variant with `.tmp` in the file name is expected to be unpacked into `/tmp` as `/tmp/golang-tip` (that's the value of [GOROOT_FINAL](https://golang.org/doc/install/source#environment) set during compilation):

```
rm -rf /tmp/golang-tip && tar -C /tmp -xzf master.linux-amd64.tar.gz
```

That allows that version to co-exist with other versions of Go and be installed without additional privileges.


# Credits

Made by Alexey Palazhchenko.

Inspired by [go-tip by Craig Peterson](https://github.com/captncraig/go-tip).


# Contributing

Pull requests that add other branches, base Docker images, OSes, and CPU architectures are welcome.
