#!/bin/bash

src_dir=$1
malicious_dir=$2
delay=$3

echo "" > directory-info.last

while true; do
    sleep "$delay"
    ls -la "$src_dir" > directory-info.new
    if cmp -s directory-info.last directory-info.new; then
        continue
    fi

    for file in "$src_dir"/*; do
      if [ -f "whitelist.txt" ]; then
        filename="${file##*/}"
        if grep -Fqx "$filename"  whitelist.txt ; then
          continue
        fi
      fi

      if [[ $file =~ \.(exe|bat|vbs|scr|ps1)$ ]] ||
          grep -Eiq "virus|trojan|malware|worm|ransomware" "$file"; then
        mv "$file" "$malicious_dir"
        echo "$file is malicious and it is DELETED"
      fi
    done
    ls -la "$src_dir" > directory-info.last
done
