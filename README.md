# OS LAB2 - SIMPLE ANTIVIRUS

### Folder Hierarchy
```text
lab_2
├── antivirus-cron.sh   # script for scheduled cron
├── antivirusd.sh       # script for daemon
├── directory-info.last*
├── directory-info.new*
├── .gitignore
├── .idea*
│   ├── editor.xml
│   ├── .gitignore
│   ├── misc.xml
│   ├── vcs.xml
│   └── workspace.xml
├── Makefile        # Makefile for managing targets
├── malicious_dir*
│   ├── file.bat
│   ├── file.cpp
│   ├── file.scr
│   ├── file.vbs
│   ├── hello.exe
│   └── malcious.exe
├── README.md 
├── restore.sh      # Review script
├── src_dir*
│   ├── hello.exe.hi
│   ├── hello.png
│   ├── hello.txt
│   └── main.c
└── whitelist.txt*

4 directories, 24 files
*: ignored by .gitignore
```
### Usage
#### Using Makefile
1. Antivirus Daemon
```shell
make
# or
make antivirus SRC_DIR=<path_to_src> MALICIOUS_DIR=<path_to_malicious> DELAY=<delay_in_sec>
```

2. Restore Tool
```shell
make restore
```
3. Clean Generated Files
```shell
make clean
```
### Manually
1. Antivirus Daemon
```shell
./antivirusd.sh <src_dir> <malicious_dir> <interval_in_sec>
```

2. Restore Tool
```shell
./restore.sh <src_dir> <malicious_dir>
```
### Flagged Extensions and Keywords
./antivirusd.sh\
```shell
-E # for regex, to use |
-q # quiet
-i # case insensetive
```
```shell
if [[ $file =~ \.(exe|bat|vbs|scr|ps1)$ ]] ||
    grep -Eiq "virus|trojan|malware|worm|ransomware" "$file"; then
    mv "$file" "$malicious_dir"
    echo "$file is malicious and it is DELETED"
fi
```

### Cron Job
To run `antivirus-cron-sh` as a cronjob

#### prerequisites
1. verify cron status
```shell 
sudo systemctl status cron
```
2. Make script executable
```shell
sudo chmod +x <path_to_antivirus-cron.sh>
```
1. Open crontab editor
```shell
crontab -e # select your favorite editor
```

2. paste the following line
```shell
* * * * * sleep 23 && cd <path_to_antivirus-cron.sh> && ./antivirus-cron.sh <path_to_src_dir> <path_to_malicious_dir>
```
3. save and quit


#### Cron Expression answer
![img.png](assets/cron-question.png)
```shell
31 0 15-21 * 5
```
### Whitelist
When a file is restored by `restore.sh` script, its name is
appended to `whitelist.txt`. The antivirus daemon will check if
the file name is in whitelist.txt and skip the deletion if it was found

1. file addition\
- `filename="${file##*/}"`: strips away everything up to the final `/` leaving
only the filename

```shell      
1) mv "$file" "$src_dir"
        echo "Restored $file to $src_dir"
        filename="${file##*/}"
        echo "$filename" >> whitelist.txt ;;
```

2. file checking 
- first check if the `whitelist.txt` file exists, then check if the file name in it
```shell
if [ -f "whitelist.txt" ]; then
    filename="${file##*/}"
    if grep -Fqx "$filename"  whitelist.txt ; then
      continue
    fi
fi
```








