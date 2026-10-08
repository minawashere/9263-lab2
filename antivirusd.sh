#!/bin/bash

src_dir=$1
malicious_dir=$2
delay=$3

ls -a -l "$src_dir" > directory-info.last
echo " " > directory-info.new

while true; do
    sleep "$delay"

    if cmp -s directory-info.last directory-info.new; then
        continue
    fi

    for file in "$src_dir"/*; do
      if [[ $file =~ \.(exe|bat|vbs|scr|ps1)$ ]] ||
          grep -Eiq "virus|trojan|malware|worm|ransomware" "$file"; then #https://stackoverflow.com/a/407334
        mv "$file" "$malicious_dir"
        echo "$file is malicious and it is DELETED"
      fi
    done

    ls -a -l "$src_dir" > directory-info.last
done
