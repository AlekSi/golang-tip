# golang-tip

[![Build](https://github.com/AlekSi/golang-tip/actions/workflows/build.yml/badge.svg?branch=main&event=schedule)](https://github.com/AlekSi/golang-tip/actions/workflows/build.yml)

Daily builds of [active Go development branches](https://github.com/golang/go/branches/active).
Available as:
* Docker images (based on [Go "Official Image"](https://github.com/docker-library/golang)) on both [Docker Hub](https://hub.docker.com/r/aleksi/golang-tip)
and [GitHub Container Registry](https://github.com/users/AlekSi/packages/container/package/golang-tip)
* [.tar.gz files](https://github.com/AlekSi/golang-tip/releases/tag/tip)

Examples for `master` / tip branch:
```sh
docker pull aleksi/golang-tip:master
docker pull ghcr.io/aleksi/golang-tip:master

curl -LO https://github.com/AlekSi/golang-tip/releases/download/tip/master.linux-amd64.tar.gz
curl -LO https://github.com/AlekSi/golang-tip/releases/download/tip/master.darwin-amd64.tar.gz
```

Currently built branches (see [here](https://github.com/AlekSi/golang-tip/blob/main/.github/workflows/build.yml)):
* `master` a.k.a tip, the next Go version
* `dev.boringcrypto` – [BoringCrypto](https://github.com/golang/go/blob/dev.boringcrypto/README.boringcrypto.md)
* `dev.fuzz` – [fuzz test support](https://github.com/golang/go/issues/44551)
* `dev.go2go` – [Go with generics](https://github.com/golang/go/blob/dev.go2go/README.go2go.md)

Inspired by [go-tip by Craig Peterson](https://github.com/captncraig/go-tip).

Pull requests that add other branches, base images, OSes, and CPU architectures are welcome.
