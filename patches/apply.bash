#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/../node
git apply ../patches/node_c_embed.patch

if [ ! -f "$SCRIPT_DIR/node_c_embed_unix.patch" ]; then
    git apply $SCRIPT_DIR/node_c_embed_unux.patch
fi