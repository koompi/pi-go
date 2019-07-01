.PHONY: all default install uninstall test build release clean package

PREFIX := /usr/local
DESTDIR :=

MAJORVERSION := 9
MINORVERSION ?= 2
PATCHVERSION := 1
VERSION ?= ${MAJORVERSION}.${MINORVERSION}.${PATCHVERSION}

LDFLAGS := -gcflags=all=-trimpath=${PWD} -asmflags=all=-trimpath=${PWD} -ldflags=-extldflags=-zrelro -ldflags=-extldflags=-znow -ldflags '-s -w -X main.version=${VERSION}'
MOD := -mod=vendor
export GO111MODULE=on
ARCH := $(shell uname -m)
GOCC := $(shell go version)
PKGNAME := pi
BINNAME := pi
PACKAGE := ${PKGNAME}_${VERSION}_${ARCH}

ifneq (,$(findstring gccgo,$(GOCC)))
	export GOPATH=$(shell pwd)/.go
	LDFLAGS := -gccgoflags '-s -w'
	MOD :=
endif

default: build

all: | clean package

install:
	install -Dm755 ${BINNAME} $(DESTDIR)$(PREFIX)/bin/${BINNAME}
	install -Dm644 doc/${PKGNAME}.8 $(DESTDIR)$(PREFIX)/share/man/man8/${PKGNAME}.8
	install -Dm644 completions/bash $(DESTDIR)$(PREFIX)/share/bash-completion/completions/${PKGNAME}
	install -Dm644 completions/zsh $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_${PKGNAME}
	install -Dm644 completions/fish $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d/${PKGNAME}.fish

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/${BINNAME}
	rm -f $(DESTDIR)$(PREFIX)/share/man/man8/${PKGNAME}.8
	rm -f $(DESTDIR)$(PREFIX)/share/bash-completion/completions/${PKGNAME}
	rm -f $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_${PKGNAME}
	rm -f $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d/${PKGNAME}.fish

test:
	gofmt -l *.go
	@test -z "$$(gofmt -l *.go)" || (echo "Files need to be linted" && false)
	go vet
	go test -v

build:
	go build -v ${LDFLAGS} -o ${BINNAME} ${MOD}

release: | test build
	mkdir ${PACKAGE}
	cp ./${BINNAME} ${PACKAGE}/
	cp ./doc/${PKGNAME}.8 ${PACKAGE}/
	cp ./completions/zsh ${PACKAGE}/
	cp ./completions/fish ${PACKAGE}/
	cp ./completions/bash ${PACKAGE}/

docker-release-aarch64:
	docker build -f build/aarch64.Dockerfile -t pi-aarch64:${VERSION} .
	docker run --name pi-aarch64 pi-aarch64:${VERSION}
	docker cp pi-aarch64:${PKGNAME}_${VERSION}_aarch64.tar.gz ${PKGNAME}_${VERSION}_aarch64.tar.gz
	docker container rm pi-aarch64

docker-release-armv7h:
	docker build -f build/armv7h.Dockerfile -t pi-armv7h:${VERSION} .
	docker create --name pi-armv7h pi-armv7h:${VERSION}
	docker cp pi-armv7h:${PKGNAME}_${VERSION}_armv7l.tar.gz ${PKGNAME}_${VERSION}_armv7h.tar.gz
	docker container rm pi-armv7h

docker-release-x86_64:
	docker build -f build/x86_64.Dockerfile -t pi-x86_64:${VERSION} .
	docker create --name pi-x86_64 pi-x86_64:${VERSION}
	docker cp pi-x86_64:${PKGNAME}_${VERSION}_x86_64.tar.gz ${PKGNAME}_${VERSION}_x86_64.tar.gz
	docker container rm pi-x86_64

docker-release: | docker-release-x86_64 docker-release-aarch64 docker-release-armv7h

docker-build:
	docker build -f build/${ARCH}.Dockerfile --build-arg MAKE_ARG=build -t pi-build-${ARCH}:${VERSION} .
	docker create --name pi-build-${ARCH} pi-build-${ARCH}:${VERSION}
	docker cp pi-build-${ARCH}:${BINNAME} ${BINNAME}
	docker container rm pi-build-${ARCH}

package: release
	tar -czvf ${PACKAGE}.tar.gz ${PACKAGE}
clean:
	rm -rf ${PKGNAME}_*
	rm -f ${BINNAME}

