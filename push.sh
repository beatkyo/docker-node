#!/bin/bash
set -e

source "version"

ARCH=${1:-$(uname -m)}

function push {
  echo
  echo "+ push"
  echo "+ image: dalexandre/node-${ARCH:?}:${NODE_VERSION:?}"
  echo

  docker push "dalexandre/node-$ARCH:$NODE_VERSION"
  docker push "dalexandre/node-$ARCH:latest"
}

function push-i386 {
	ARCH="i386"

	push
}

function push-amd64 {
	ARCH="amd64"

	push
}

function push-aarch64 {
	ARCH="arm64v8"

	push
}

function push-x86_64 {
	push-amd64
}

push-$ARCH
