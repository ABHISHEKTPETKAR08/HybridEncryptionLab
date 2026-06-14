#!/bin/bash

echo "====================================="
echo " AES-256 File Decryption"
echo "====================================="
echo

read -p "Enter encrypted file (.enc): " ENCFILE

if [ ! -f "$ENCFILE" ]; then
echo "[ERROR] Encrypted file not found."
exit 1
fi

read -s -p "Enter decryption password: " PASSWORD
echo

mkdir -p recovered

BASENAME=$(basename "$ENCFILE" .enc)

openssl enc -d -aes-256-cbc 
-in "$ENCFILE" 
-out "recovered/${BASENAME}" 
-pass pass:"$PASSWORD"

if [ $? -ne 0 ]; then
echo "[ERROR] Incorrect password or corrupted file."
exit 1
fi

echo
echo "[+] Decryption Complete"
echo "[+] Recovered File: recovered/${BASENAME}"
