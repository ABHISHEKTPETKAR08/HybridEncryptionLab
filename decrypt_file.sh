#!/bin/bash

echo "====================================="
echo " Hybrid Decryption Demo"
echo " AES-256 + RSA-2048"
echo "====================================="
echo

read -p "Enter encrypted file (.enc): " ENCFILE

if [ ! -f "$ENCFILE" ]; then
echo "[ERROR] Encrypted file not found."
exit 1
fi

read -p "Enter encrypted AES key file (.key.enc): " KEYFILE

if [ ! -f "$KEYFILE" ]; then
echo "[ERROR] Encrypted AES key file not found."
exit 1
fi

PRIVKEY="keys/private.pem"

if [ ! -f "$PRIVKEY" ]; then
echo "[ERROR] Private key not found: $PRIVKEY"
exit 1
fi

mkdir -p recovered

TEMP_AES=$(mktemp)

echo "[+] Recovering AES key using RSA private key..."

openssl pkeyutl 
-decrypt 
-inkey "$PRIVKEY" 
-in "$KEYFILE" 
-out "$TEMP_AES"

if [ $? -ne 0 ]; then
echo "[ERROR] Failed to recover AES key."
rm -f "$TEMP_AES"
exit 1
fi

BASENAME=$(basename "$ENCFILE" .enc)

echo "[+] Decrypting file using AES-256..."

openssl enc -d -aes-256-cbc 
-in "$ENCFILE" 
-out "recovered/$BASENAME" 
-pass file:"$TEMP_AES"

if [ $? -ne 0 ]; then
echo "[ERROR] File decryption failed."
rm -f "$TEMP_AES"
exit 1
fi

rm -f "$TEMP_AES"

echo
echo "====================================="
echo " Decryption Completed"
echo "====================================="
echo "Recovered File:"
echo "recovered/$BASENAME"
echo "====================================="
