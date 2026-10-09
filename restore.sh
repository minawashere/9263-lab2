#!/bin/bash

src_dir=$1
malicious_dir=$2

while true; do
  if [ "$(ls "$malicious_dir" | wc -l)" -eq 0 ]; then # https://linuxvox.com/blog/how-to-count-files-in-directory-in-linux/#method-1-using-ls-and-wc-commands
    echo "No malicious files to review"
    break
  fi

  count=0
  for file in "$malicious_dir"*; do
    echo "$count $file"
    ((count++))
  done

  echo " "
  read -p "Select File By Number: " selected_file # https://www.geeksforgeeks.org/linux-unix/bash-script-read-user-input/
  echo "1 restore file back"
  echo "2 permanently delete file"
  echo "3 back to files"
  read -p "Select option: " selected_option

  count=0
  for file in "$malicious_dir"*; do
    if [ "$count" -eq "$selected_file" ]; then
      case "$selected_option" in
      1) mv "$file" "$src_dir"
        echo "Restored $file to $src_dir"
        filename="${file##*/}"
        echo "$filename" >> whitelist.txt ;;
      2) rm "$file"
        echo " $file permanently deleted";;
      3) break ;;
      esac
    fi
    ((count++))
  done
done


