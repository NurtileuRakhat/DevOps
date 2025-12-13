#!/bin/bash


dir="dir"
archive_dir=$1
unzip archive_1.zip -d "$dir"
i=2
while grep -r "not empty" "$dir"
do
    unzip -o "$dir/archive_$i.zip" -d "$dir"
    rm -r "$dir/archive_$i.zip" "$dir/empty.txt"
    ((i++))
done
echo $i

for file in "$dir"/*txt; do
    echo "_22B030581" >> "$file"
    CodeWord="not empty "$(cat "$file")
done
echo "$CodeWord"
cd "$dir"
zip "archive_$i.zip" *
for file in "$dir"/*txt; do
    rm "$file"
done
echo "$CodeWord" > empty.txt
((i--))
while [[ $i -gt 0 ]]; do
    zip "archive_$i.zip" "archive_$((i+1)).zip" empty.txt
    rm "archive_$((i+1)).zip"
    ((i--))
done
cd ..
mv $dir/archive_1.zip ./archive_1_new.zip
rm -r dir