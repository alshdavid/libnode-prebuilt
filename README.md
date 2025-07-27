# Prebuilt `libnode` binaries

## Installation

Downloads are in the releases

```bash
mkdir -p /opt/libnode
curl -L --url https://github.com/alshdavid/libnode-prebuilt/releases/download/v22.15.0/libnode-linux-amd64.tar.xz \
  | tar -xJvf - -C /opt/libnode
```

## Patches for C FFI

This includes [this PR](https://github.com/nodejs/node/pull/58207) which adds an extern C function `node_embedding_main` for embedders coming from languages that cannot use C++ bindings (Like Rust, C#, etc).
