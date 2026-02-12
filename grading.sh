# gradingScript
# run this to work ./grading.sh expected_output.txt output.txt < student_keys.txt


while IFS= read -r key; do
    [ -n "$key" ] && git clone "https://github.com/CSE2307SP26/${key}.git"
    cd "${key}"
    git checkout cipher
    git pull
    cd ..
done < "$1"