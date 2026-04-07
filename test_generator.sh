#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <target_root_directory>"
    exit 1
fi

CURRENT_DATE=$(date +%Y-%m-%d)
RETENTION_DATE=$(date -d "11 days ago" +%Y-%m-%d)
RECENT_DATE=$(date -d "5 days ago" +%Y-%m-%d)

ROOT="$1"

createFiles() {
	local dir="$1"

	make_file() {
	        local fname="$1"
	        echo "Content of $fname - Timestamp: $(date +%H:%M:%S.%N)" > "$dir/$fname"
	}
	
	# New logs
	make_file "app.log.old"
    make_file "important.log.txt"
    make_file "database.log.backup.csv"
    make_file "web server.log.info"

	# File already renamed and gzipped
	touch "$dir/already_processed.$CURRENT_DATE.log.old.gz"

	# Expired gzip file -> deleted
	touch -d "11 days ago" "$dir/expired_archive.$RETENTION_DATE.log.bak.gz"

	# Recent gzip file -> kept
	touch -d "5 days ago" "$dir/recent_archive.$RECENT_DATE.log.bak.gz"

	# Old, not gzipped file -> kept for safety measure
	touch -d "30 days ago" "$dir/very_old_uncompressed.log.old" 
	
	touch "$dir/ignore.log"
	touch "$dir/manual.txt"
	touch "$dir/log.txt.old"
	touch "$dir/.hidden.log.tmp"
}

mkdir -p "$ROOT"
createFiles "$ROOT"

SUBDIRS=("services" "services/database" "legacy")
for sub in "${SUBDIRS[@]}"; do
	TARGET_DIR="$ROOT/$sub"
	mkdir -p "$TARGET_DIR"
	createFiles "$TARGET_DIR"
done

echo "Test cases created successfully"
