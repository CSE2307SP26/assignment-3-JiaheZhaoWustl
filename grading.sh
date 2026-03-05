# gradingScript
# run this to work ./grading.sh expected_output.txt output.txt < student_keys.txt
# Deadline: Wed Feb 12, 2026 10am Central
# Late submissions get score 0

EXPECTED="$1"
OUTPUT="$2"
DIR=$(pwd)
DEADLINE_TS=1770912000
>"$OUTPUT"

while IFS= read -r key; do
    key="${key%%$'\r'}"
    [ -z "$key" ] && continue
    git clone "https://github.com/CSE2307SP26/${key}.git"
    cd "${key}"
    git checkout cipher

    commit_ts=$(git log -1 --format='%ct')
    if [ -n "$commit_ts" ] && [ "$commit_ts" -gt "$DEADLINE_TS" ]; then
        echo "$key 0" >> "$DIR/$OUTPUT"
        cd ..
        continue
    fi

    if javac Cipher.java; then
        java Cipher
        if [ -f output.txt ] && diff -q output.txt "$DIR/$EXPECTED"; then
            echo "$key 1" >> "$DIR/$OUTPUT"
        else
            echo "$key 0" >> "$DIR/$OUTPUT"
        fi
    else
        echo "$key 0" >> "$DIR/$OUTPUT"
    fi

#    commit_time=$(git log -1 --format='%cd' --date=local)
#    echo "$key: $commit_time"

    cd ..
done