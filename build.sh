#!/bin/bash
set -e

source "version"

ARCH=${1:-$(uname -m)}

function build {
  echo
  echo "+ build"
  echo "+ arch: ${ARCH:?}"
  echo "+ image: ${IMAGE:?}"
  echo "+ node version: ${NODE_VERSION:?}"
  echo "+ yarn version: ${YARN_VERSION:?}"
  echo

  export IMAGE
  export NODE_VERSION
  export YARN_VERSION

  docker build \
    --pull \
    --build-arg "IMAGE=$IMAGE" \
    --build-arg "NODE_VERSION=$NODE_VERSION" \
    --build-arg "YARN_VERSION=$YARN_VERSION" \
    --tag "dalexandre/node-$ARCH:$NODE_VERSION" \
    --tag "dalexandre/node-$ARCH:latest" \
    .
}

function build-i386 {
  ARCH="i386"
  IMAGE="i386/alpine"

  build
}

function build-amd64 {
  ARCH="amd64"
  IMAGE="amd64/alpine"

  build
}

function build-aarch64 {
  ARCH="arm64v8"
  IMAGE="arm64v8/alpine"

  build
}

function build-x86_64 { 
  build-amd64 
}

build-${ARCH:?}
