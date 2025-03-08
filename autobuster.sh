#!/bin/bash

# Check if Gobuster is installed
if ! command -v gobuster &> /dev/null; then
    echo -e "\e[31m[ERROR]\e[0m Gobuster is not installed. Please install it first."
    exit 1
fi

# Check if an argument is provided
if [[ -z "$1" ]]; then
    echo -e "\e[33mUsage: ./autobuster.sh <IP or URL>\e[0m"
    exit 1
fi

# Create results directory if not exists
mkdir -p results

# Define timestamp for logs
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
LOGFILE="results/gobuster_$TIMESTAMP.txt"

# Display Banner
cat << "EOF"
    _   _   _ _____ ___  ____  _   _ ____ _____ _____ ____  
   / \ | | | |_   _/ _ \| __ )| | | / ___|_   _| ____|  _ \ 
  / _ \| | | | | || | | |  _ \| | | \___ \ | | |  _| | |_) |
 / ___ \ |_| | | || |_| | |_) | |_| |___) || | | |___|  _ < 
/_/   \_\___/  |_| \___/|____/ \___/|____/ |_| |_____|_| \_\  v3.0
  			github.com/xcyraxx & github.com/hafiz-shamnad
                                                  
EOF

# Display Options
echo -e "\e[36mSelect an option:\e[0m"
echo "[1] Directory Enumeration"
echo "[2] DNS Subdomain Enumeration"
echo "[3] Virtual Host Enumeration"
echo -n ">> "
read option

# Directory Enumeration
if [[ $option == 1 ]]; then
    path="/usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt"
    echo -n "Wordlist path (default: $path): "
    read list
    [[ -n "$list" ]] && path=$list
    
    echo -n "Number of threads (default 10): "
    read threads
    [[ -z "$threads" ]] && threads=10

    echo -n "Enable recursion? (y/N): "
    read recursive
    [[ "$recursive" =~ ^[Yy]$ ]] && recursive="--recursive" || recursive=""

    echo -e "\e[32m[INFO]\e[0m Starting directory enumeration on $1..."
    gobuster dir -u "$1" -w "$path" -t "$threads" $recursive | tee "$LOGFILE"
fi

# DNS Enumeration
if [[ $option == 2 ]]; then
    path="/usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt"
    echo -n "Wordlist path (default: $path): "
    read list
    [[ -n "$list" ]] && path=$list

    echo -n "Custom DNS resolver (default: 8.8.8.8): "
    read resolver
    [[ -z "$resolver" ]] && resolver="8.8.8.8"

    echo -e "\e[32m[INFO]\e[0m Starting DNS enumeration on $1..."
    gobuster dns -r "$resolver" -d "$1" -w "$path" | tee "$LOGFILE"
fi

# Virtual Host Enumeration
if [[ $option == 3 ]]; then
    path="/usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt"
    echo -n "Wordlist path (default: $path): "
    read list
    [[ -n "$list" ]] && path=$list

    echo -e "\e[32m[INFO]\e[0m Starting virtual host enumeration on $1..."
    gobuster vhost -u "$1" -t 50 -w "$path" | tee "$LOGFILE"
fi

echo -e "\e[36m[INFO]\e[0m Results saved to: $LOGFILE"