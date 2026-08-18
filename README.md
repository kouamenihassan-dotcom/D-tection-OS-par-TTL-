
# Projet 02 - Détection de Système d'Exploitation par TTL

![Kali Linux](https://img.shields.io/badge/Kali_Linux-557C94?style=for-the-badge&logo=kalilinux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📋 Description

Ce projet consiste à identifier le système d'exploitation d'une machine distante en analysant la valeur du champ **TTL (Time To Live)** dans les paquets ICMP (ping). Cette technique de reconnaissance passive permet une première estimation rapide et non intrusive de l'OS cible.

## 🎯 Objectifs

- Comprendre le mécanisme du TTL dans les requêtes ICMP
- Identifier les valeurs TTL par défaut des principaux OS
- Développer un script d'automatisation en Bash
- Analyser les limites de cette méthode de détection

## 🛠️ Prérequis

- Kali Linux (ou tout système Linux avec ping)
- Deux machines cibles (Windows et Linux)
- Connexion réseau fonctionnelle

## 📊 Valeurs TTL par défaut

| Système d'Exploitation | TTL Initial |
|------------------------|-------------|
| Windows (7/8/10/11/Server) | 128 |
| Linux (Ubuntu/Debian/etc.) | 64 |
| macOS / iOS / Android | 64 |
| Cisco Routeurs/Switches | 255 |
| Solaris | 255 |

## 🚀 Installation et Utilisation

### 1. Télécharger le script

```bash
git clone https://github.com/votre-username/Projet-02-Detection-OS-TTL.git
cd Projet-02-Detection-OS-TTL
```

### 2. Rendre le script exécutable

```bash
chmod +x detect_os.sh
```

### 3. Exécuter le script

```bash
./detect_os.sh <ADRESSE_IP_CIBLE>
```

## 📸 Résultats d'Exécution

### Test sur une machine Windows (TTL=128)

```bash
hassan@khassan:~$ ping -c 4 172.20.10.5
PING 172.20.10.5 (172.20.10.5) 56(84) bytes of data.
64 bytes from 172.20.10.5: icmp_seq=1 ttl=128 time=3.68 ms
64 bytes from 172.20.10.5: icmp_seq=2 ttl=128 time=6.84 ms
64 bytes from 172.20.10.5: icmp_seq=3 ttl=128 time=3.56 ms
64 bytes from 172.20.10.5: icmp_seq=4 ttl=128 time=3.62 ms

--- 172.20.10.5 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
RTT min/avg/max/mdev = 3.564/4.424/6.838/1.394 ms

hassan@khassan:~$ ./detect_os.sh 172.20.10.5
[+] TTL détecté : 128
[+] OS probable : Windows (TTL=128 ou moins)
```

### Test sur une machine Linux (TTL=64)

```bash
hassan@khassan:~$ ping -c 4 172.20.10.1
PING 172.20.10.1 (172.20.10.1) 56(84) bytes of data.
64 bytes from 172.20.10.1: icmp_seq=1 ttl=64 time=14.3 ms
64 bytes from 172.20.10.1: icmp_seq=2 ttl=64 time=10.2 ms
64 bytes from 172.20.10.1: icmp_seq=3 ttl=64 time=4.02 ms
64 bytes from 172.20.10.1: icmp_seq=4 ttl=64 time=10.2 ms

--- 172.20.10.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
RTT min/avg/max/mdev = 4.023/9.664/14.278/3.661 ms

hassan@khassan:~$ ./detect_os.sh 172.20.10.1
[+] TTL détecté : 64
[+] OS probable : Linux, macOS, ou Unix (TTL=64 ou moins)
```

## 💻 Code du Script

```bash
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
```

## 🔍 Analyse et Limites

### ✅ Avantages
- **Rapide et léger** : Une seule requête ICMP suffit
- **Non intrusif** : Pas de scan de ports, difficile à détecter
- **Automatisable** : Facile à intégrer dans des scripts de reconnaissance

### ⚠️ Limitations
- **Faux positifs** : Les valeurs TTL peuvent être modifiées par l'administrateur
- **Influence du réseau** : Les routeurs intermédiaires réduisent le TTL
- **Précision limitée** : Ne distingue pas toujours entre Linux et macOS (même TTL=64)

### 🛡️ Recommandations

1. **Combiner avec d'autres techniques** : Utiliser `nmap -O` pour une détection plus précise
2. **Analyse du contexte** : Considérer l'environnement réseau (nombre de routeurs)
3. **Automatisation** : Intégrer dans des scripts de reconnaissance à grande échelle

## 📚 Ressources

- [RFC 791 - Internet Protocol (TTL)](https://datatracker.ietf.org/doc/html/rfc791)
- [Nmap OS Detection Guide](https://nmap.org/book/osdetect.html)
- [Linux Ping Manual](https://man7.org/linux/man-pages/man8/ping.8.html)


## 👤 Auteur

**Hassan KHASSAN**

- 🔗 [LinkedIn](https://www.linkedin.com/in/kouameni-hassan-1062233bb?utm_source=share_via&utm_content=profile&utm_medium=member_ios)
- 🐙 [GitHub](https://github.com/kouamenihassan-dotcom)



⭐ N'hésitez pas à mettre une étoile si ce projet vous a été utile !


