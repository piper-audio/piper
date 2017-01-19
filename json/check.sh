#!/bin/bash

mydir=$(dirname "$0")

set -eu

echo

for ex in "$mydir"/examples/*.json ; do
    echo "Checking $ex..." 1>&2
    jsonschema -i "$ex" "$mydir"/schema/$(basename "$ex" | sed 's/-[^.]*//')
done

for s in "$mydir"/schema/*.json ; do
    if [ ! -f "$mydir"/examples/$(basename "$s") ]; then
        if ! ls -1 "$mydir"/examples/$(basename "$s" .json)-*.json >/dev/null 2>&1; then
	    echo "WARNING: No example file for schema $s"
        fi
    fi
done

echo OK
