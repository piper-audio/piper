#!/bin/bash


for ex in examples/*.json ; do
    echo "Checking $ex..." 1>&2
    jsonschema -i "$ex" schema/$(basename "$ex" | sed 's/-[^.]*//')
done

for s in schema/*.json ; do
    if [ ! -f examples/$(basename "$s") ]; then
        if ! ls -1 examples/$(basename "$s" .json)-*.json >/dev/null 2>&1; then
	    echo "WARNING: No example file for schema $s"
        fi
    fi
done

