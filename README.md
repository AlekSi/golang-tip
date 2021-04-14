# golang-tip

[![Docker](https://github.com/AlekSi/golang-tip/actions/workflows/docker.yml/badge.svg?branch=main&event=schedule)](https://github.com/AlekSi/golang-tip/actions/workflows/docker.yml)
[![TarGz](https://github.com/AlekSi/golang-tip/actions/workflows/targz.yml/badge.svg?branch=main&event=schedule)](https://github.com/AlekSi/golang-tip/actions/workflows/targz.yml)

Daily builds of [active Go development branches](https://github.com/golang/go/branches/active).
Available on both [Docker Hub](https://hub.docker.com/r/aleksi/golang-tip)
and [GitHub Container Registry](https://github.com/users/AlekSi/packages/container/package/golang-tip).

```
docker pull aleksi/golang-tip:master
docker pull ghcr.io/aleksi/golang-tip:master
```

Currently built branches / Docker tags (see [here](https://github.com/AlekSi/golang-tip/blob/main/.github/workflows/build.yml)):
* `master` a.k.a tip, the next Go version
* `dev.boringcrypto` – [BoringCrypto](https://github.com/golang/go/blob/dev.boringcrypto/README.boringcrypto.md)
* `dev.fuzz` – [fuzz test support](https://github.com/golang/go/issues/44551)
* `dev.go2go` – [Go with generics](https://github.com/golang/go/blob/dev.go2go/README.go2go.md)

Based on [Go "Official Image"](https://github.com/docker-library/golang) and inspired by [go-tip by Craig Peterson](https://github.com/captncraig/go-tip).

Pull requests that add other branches, base images, OSes, and CPU architectures are welcome.
