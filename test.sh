#!/bin/bash

set -eu

for ex in examples/*.json ; do
    echo "Checking $ex..." 1>&2
    jsonschema -i "$ex" schema/$(basename "$ex")
done

for s in schema/*.json ; do
    if [ ! -f examples/$(basename "$s") ]; then
	echo "WARNING: No example file for schema $s"
    fi
done

