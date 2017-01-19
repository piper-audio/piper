#!/bin/bash

mydir=$(dirname "$0")

set -eu

echo

for c in "$mydir"/*.capnp ; do
    echo "Checking $c..." 1>&2
    capnpc -o- "$c" >/dev/null
done

echo OK
