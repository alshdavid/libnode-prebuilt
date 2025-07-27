#!/usr/bin/env bash

CURR_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=$(dirname $CURR_DIR)

echo $ROOT_DIR

for name in "$ROOT_DIR/patches/all/*.pr"; do  
  echo Fetching $(basename $name)
  curl -L -o $(dirname $name)/$(basename $name).patch $(cat $name).patch
done

if [ ! -f "$ROOT_DIR/patches/$1" ]; then
  for name in "$ROOT_DIR/patches/$1/*.pr"; do
    if [ ! -f $name ]; then
      break
    fi
    echo Fetching $(basename $name)
    curl -L -o $(dirname $name)/$(basename $name).patch $(cat $name).patch
  done
fi

cd $ROOT_DIR/node

for name in "$ROOT_DIR/patches/all/*.patch"; do  
  echo Applying $name
  git apply $name
done

if [ ! -f "$ROOT_DIR/patches/$1" ]; then
  for name in "$ROOT_DIR/patches/$1/*.patch"; do  
    if [ ! -f $name ]; then
      break
    fi
    echo Applying $name
    git apply $name
  done
fi