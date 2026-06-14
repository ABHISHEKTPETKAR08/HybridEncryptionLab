#!/bin/bash

echo "====================================="
echo " Hybrid Encryption Demo"
echo " AES-256 + RSA-2048"
echo "====================================="
echo

read -p "Enter file to encrypt: " FILE

if [ ! -f "$FILE" ]; then
echo "[ERROR] File not found."
exit 1
fi

PUBKEY="keys/public.pem"

if [ ! -f "$PUBKEY" ]; then
echo "[ERROR] Public key not found: $PUBKEY"
exit 1
fi

mkdir -p encrypted

AESKEY=$(mktemp)

echo "[+] Generating AES key..."
openssl rand -hex 32 > "$AESKEY"

BASENAME=$(basename "$FILE")

echo "[+] Encrypting file using AES-256..."
openssl enc -aes-256-cbc 
-salt 
-in "$FILE" 
-out "encrypted/${BASENAME}.enc" 
-pass file:"$AESKEY"

echo "[+] Encrypting AES key using RSA..."
openssl pkeyutl 
-encrypt 
-pubin 
-inkey "$PUBKEY" 
-in "$AESKEY" 
-out "encrypted/${BASENAME}.key.enc"

rm "$AESKEY"

echo
echo "====================================="
echo " Encryption Completed"
echo "====================================="
echo "Encrypted File:"
echo "encrypted/${BASENAME}.enc"
echo
echo "Encrypted AES Key:"
echo "encrypted/${BASENAME}.key.enc"
echo
echo "Keep your RSA private key safe."
echo "====================================="
