#!/usr/bin/env nix-shell
#!nix-shell -i bash -A env

# usage: ./melpa-packages.sh --melpa PATH_TO_MELPA_CLONE

## env var for curl
export SSL_CERT_FILE=${SSL_CERT_FILE:-/etc/ssl/certs/ca-certificates.crt}

cabal run melpa2nix -- --work /tmp/melpa2nix "$@"
