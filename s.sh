#!/bash/bin

# الألوان للجمالية (بما أنك تحب التيرمينال الأخضر)
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${GREEN}[+] بدأت عملية تحويل أوبنتو إلى ترسانة كالي...${NC}"

# 1. تحديث مستودعات أوبنتو الحالية
echo -e "${GREEN}[+] تحديث حزم النظام الحالية...${NC}"
sudo apt update && sudo apt upgrade -y

# 2. تثبيت المتطلبات الأساسية
echo -e "${GREEN}[+] تثبيت gnupg و wget...${NC}"
sudo apt install gnupg wget -y

# 3. إضافة مفتاح أمان كالي (GPG Key)
echo -e "${GREEN}[+] إضافة مفتاح GPG الخاص بكالي...${NC}"
wget -q -O - https://archive.kali.org/archive-key.asc | sudo apt-key add -

# 4. إضافة مستودعات كالي (Rolling Release)
echo -e "${GREEN}[+] إضافة مستودعات Kali Rolling...${NC}"
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list

# 5. تحديث القائمة بعد إضافة المستودع الجديد
echo -e "${GREEN}[+] تحديث قائمة الحزم الجديدة...${NC}"
sudo apt update

# 6. تثبيت الأدوات الأساسية (Metasploit, Nmap, Burp Suite)
echo -e "${GREEN}[+] تثبيت الأدوات الأساسية (قد يستغرق وقتاً)...${NC}"
sudo apt install nmap metasploit-framework burpsuite -y

echo -e "${GREEN}[✔] اكتملت المهمة بنجاح يا Zero! أوبنتو الآن يمتلك قوى كالي.${NC}"
 
