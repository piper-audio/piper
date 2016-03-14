#!/bin/bash

set -eu

for ex in examples/*.json ; do
    echo "Checking $ex..." 1>&2
    jsonschema -i "$ex" schema/$(basename "$ex")
done

