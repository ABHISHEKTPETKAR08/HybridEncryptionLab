#!/bin/bash

echo "====================================="
echo " AES-256 File Encryption"
echo "====================================="
echo

read -p "Enter file to encrypt: " FILE

if [ ! -f "$FILE" ]; then
echo "[ERROR] File not found."
exit 1
fi

read -s -p "Enter encryption password: " PASSWORD
echo

mkdir -p encrypted

BASENAME=$(basename "$FILE")

openssl enc -aes-256-cbc 
-salt 
-in "$FILE" 
-out "encrypted/${BASENAME}.enc" 
-pass pass:"$PASSWORD"

echo
echo "[+] Encryption Complete"
echo "[+] Encrypted File: encrypted/${BASENAME}.enc"
