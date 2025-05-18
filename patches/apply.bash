#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/../node

for name in "$SCRIPT_DIR/all/*.patch"; do  
    echo Applying $name
    git apply $name
done

for name in "$SCRIPT_DIR/$1/*.patch"; do  
    if [ ! -f $name ]; then
        break
    fi
    echo Applying $name
    git apply $name
done
