#!/bin/bash
# Usage: ./grading.sh expected_output.txt output.txt < student_keys.txt
# Deadline: Wed Feb 12, 2026 10am Central

EXPECTED="$1"
OUTPUT="$2"
DIR=$(pwd)
>"$OUTPUT"

while IFS= read -r key; do
    [ -z "$key" ] && continue
    cd "$DIR"

    git clone -q "https://github.com/CSE2307SP26/${key}.git" 2>/dev/null
    cd "${key}" 2>/dev/null || { echo "$key 0" >> "$DIR/$OUTPUT"; continue; }

    git checkout cipher 2>/dev/null
    git pull -q 2>/dev/null

    # Last commit before deadline (Central time)
    commit=$(TZ="America/Chicago" git rev-list -n 1 --before="2026-02-12 10:00" cipher 2>/dev/null)
    if [ -z "$commit" ]; then
        echo "$key 0" >> "$DIR/$OUTPUT"
    else
        git checkout -q "$commit" 2>/dev/null
        if [ -f Cipher.java ] && javac Cipher.java 2>/dev/null; then
            java Cipher 2>/dev/null | diff -q - "$DIR/$EXPECTED" >/dev/null 2>&1 && echo "$key 1" >> "$DIR/$OUTPUT" || echo "$key 0" >> "$DIR/$OUTPUT"
        else
            echo "$key 0" >> "$DIR/$OUTPUT"
        fi
    fi
done
