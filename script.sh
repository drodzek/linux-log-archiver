#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <target_root_directory>"
	exit 1
fi

ROOT="$1"
CURRENT_DATE=$(date +%Y-%m-%d_%H%M)

find "$ROOT" -type f -name "*.log.*" ! -name "*.gz" | while read -r file; do
	dir=$(dirname "$file")
	filename=$(basename "$file")

	prefix="${filename%%.log.*}"
	remaining="${filename#*.log.}"

	new_filename="${prefix}.${CURRENT_DATE}.log.${remaining}"

	mv "$file" "$dir/$new_filename"
	gzip "$dir/$new_filename"

	echo "Processed: $filename -> $new_filename.gz"
done

echo "Deleting archives older than 10 days"
find "$ROOT" -type f -name "*.log.*.gz" -mtime +10 -delete

echo "Done"
