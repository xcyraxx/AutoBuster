#!/bin/bash
if [[ -z "$1" ]]; then
        echo "Usage: ./autogob.sh <IP or Url>"
        exit
    fi

cat << EOF
____ _  _ ___ ____ ___  _  _ ____ ___ ____ ____ 
|__| |  |  |  |  | |__] |  | [__   |  |___ |__/ 
|  | |__|  |  |__| |__] |__| ___]  |  |___ |  \ v1.0
  			    github.com/xcyraxx
                                                
Select option:
[1] Directory
[2] DNS
[3] VHost
EOF

echo -n ">>"
read option

if [[ $option == 1 ]]; then
	path=/usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt
	echo -n "Wordlist path (default directory-list-2.3-medium.txt): "
	read list
	if ! [[ -z "$list" ]]; then
		path=$list
	fi
	gobuster dir -u $1 -w $path 
fi

if [[ $option == 2 ]]; then
    path=/usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
    echo -n "Wordlist path (default subdomains-top1million-5000.txt): "
    read list
    if ! [[ -z "$list" ]]; then
        path=$list
    fi
    gobuster dns -r 8.8.8.8 -d $1 -w $path 
fi

if [[ $option == 2 ]]; then
    path=/usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
    echo -n "Wordlist path (default subdomains-top1million-5000.txt): "
    read list
    if ! [[ -z "$list" ]]; then
        path=$list
    fi
    gobuster vhost -u $1 -t 50 -w $path
fi
