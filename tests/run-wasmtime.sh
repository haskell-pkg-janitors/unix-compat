#!/usr/bin/env sh

TMP="$(mktemp -d --suffix=-unix-compat)"
trap 'rm -rf -- "$TMP"' EXIT
wasmtime --dir "$TMP::/" "$@"
exit "$?"
