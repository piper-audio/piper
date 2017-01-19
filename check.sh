#!/bin/bash

mydir=$(dirname "$0")

set -eu

"$mydir"/capnp/check.sh
"$mydir"/json/check.sh
