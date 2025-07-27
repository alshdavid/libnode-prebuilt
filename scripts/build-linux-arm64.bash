#!/usr/bin/env bash
set -e 

# Tested on Ubuntu 22.04

os="linux"
arch="arm64"

function prepare() {
  export DEBIAN_FRONTEND="noninteractive"
  apt-get update --yes 
  apt-get install --yes \
    ca-certificates \
    curl \
    gnupg \
    git \
    nodejs \
    python3 \
    python3-pip \
    gcc \
    g++ \
    make \
    nasm \
    ccache \
    linux-libc-dev \
    build-essential \
    libssl-dev \
    software-properties-common \
    wget \
    cmake \
    jq
}

function clone() {
  if [ "$NODEJS_GIT" = "" ]; then
    echo "Missing \$NODEJS_GIT"
    exit 1
  fi

  if [ "$NODEJS_BRANCH" = "" ]; then
    echo "Missing \$NODEJS_BRANCH"
    exit 1
  fi

  git config --global safe.directory '*'
  git clone "$NODEJS_GIT" --branch "$NODEJS_BRANCH" --depth=1 ./node
}

function build() {
  cd ./node  
  ./configure \
    --shared \
    --dest-cpu arm64 \
    --dest-os linux \
    --no-cross-compiling \
    --with-arm-float-abi hard \
    --with-arm-fpu neon
  make -j8
  cd ../
}

function copy() {
  rm -rf release/libnode-$os-$arch
  mkdir -p release/libnode-$os-$arch
  cp ./node/out/Release/libnode.* ./release/libnode-$os-$arch
  cp ./node/out/Release/node ./release/libnode-$os-$arch
  ln ./release/libnode-$os-$arch/libnode.* ./release/libnode-$os-$arch/libnode.so
}

function default() {
  prepare
  clone
  build
  copy
}

if [ "$1" = "" ]; then
  default
else
  $1
fi