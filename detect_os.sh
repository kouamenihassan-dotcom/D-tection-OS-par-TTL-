#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

TARGET_IP=$1

# Effectue le ping et extrait le TTL
TTL=$(ping -c 1 $TARGET_IP | grep -o 'ttl=[0-9]*' | cut -d '=' -f 2)

# Vérifie si le ping a réussi
if [ -z "$TTL" ]; then
    echo "[-] Hôte $TARGET_IP non joignable ou le ping a échoué."
    exit 1
fi

echo "[+] TTL détecté : $TTL"

# Détermine l'OS probable
if [ "$TTL" -ge 0 ] && [ "$TTL" -le 64 ]; then
    echo "[+] OS probable : Linux, macOS, ou Unix (TTL=64 ou moins)"
elif [ "$TTL" -ge 65 ] && [ "$TTL" -le 128 ]; then
    echo "[+] OS probable : Windows (TTL=128 ou moins)"
elif [ "$TTL" -ge 129 ] && [ "$TTL" -le 255 ]; then
    echo "[+] OS probable : Cisco ou Solaris (TTL=255)"
else
    echo "[-] OS non identifié."
fi
