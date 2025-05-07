#!/usr/bin/env bash
set -e 

os="macos"
arch="amd64"

function prepare() {
  xcodebuild -version
  sudo xcode-select --switch /Library/Developer/CommandLineTools/
  xcodebuild -version

  sudo chown -R $(whoami) $(brew --prefix)/*

  # homebrew fails to update python 3.9.1 to 3.9.1.1 due to unlinking failure
  sudo rm -f /usr/local/bin/2to3 || true
  # homebrew fails to update python from 3.9 to 3.10 due to another unlinking failure
  sudo rm -f /usr/local/bin/idle3 || true
  sudo rm -f /usr/local/bin/pydoc3 || true
  sudo rm -f /usr/local/bin/python3 || true
  sudo rm -f /usr/local/bin/python3-config || true

  brew install git node ninja nasm ccache
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

  git clone "$NODEJS_GIT" --branch "$NODEJS_BRANCH" --depth=1 ./node
}

function build() {
  cd ./node  
  ./configure \
    --shared \
    --dest-cpu x64 \
    --dest-os mac

  make -j8
  cd ../
}

function copy() {
  rm -rf release/libnode-$os-$arch
  mkdir -p release/libnode-$os-$arch
  cp ./node/out/Release/libnode.* ./release/libnode-$os-$arch
  cp ./node/out/Release/node ./release/libnode-$os-$arch
  ln ./release/libnode-$os-$arch/libnode.* ./release/libnode-$os-$arch/libnode.dylib
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