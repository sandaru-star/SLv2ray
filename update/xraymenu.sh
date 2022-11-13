#!/bin/bash
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
clear
domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "Xray TLS" | cut -d: -f2|sed 's/ //g')"
nontls="$(cat ~/log-install.txt | grep -w "Xray None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${CLIENT_NAME}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#xray-xray-tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/config.json
sed -i '/#xray-xray-nontls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'"' /etc/xray/config.json
cat>/etc/xray/xray-$user-tls.json
xrayxray1="vless://${uuid}@${domain}:8443?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-splice&sni=SL-VPN#${user}"
EOF
cat>/etc/xray/xray-$user-nontls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "555",
      "id": "${uuid}",
      "aid": "0",
      "net": "tcp",
      "path": "/vmess/",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF
xray_base642=$( base64 -w 0 <<< $xray_json2)

xrayxray2="vmess://$(base64 -w 0 /etc/xray/xray-$user-nontls.json)"

rm -rf /etc/xray/xray-$user-nontls.json
systemctl restart xray.service
service cron restart
clear
echo -e ""
echo -e "======-XRAYS/VMESS-======"
echo -e "Remarks     : ${user}"
echo -e "IP/Host     : ${MYIP}"
echo -e "Address     : ${domain}"
echo -e "Port TLS    : 8443"
echo -e "Port No TLS : 555"
echo -e "User ID     : ${uuid}"
echo -e "Alter ID    : 0"
echo -e "Security    : auto"
echo -e "Network     : tcp"
echo -e "Path        : /vmess/"
echo -e "Created     : $hariini"
echo -e "Expired     : $exp"
echo -e "========================="
echo -e "Link TLS    : ${xrayxray1}"
echo -e "========================="
echo -e "Link No TLS : ${xrayxray2}"
echo -e "========================="
echo -e "Script By Lakmal Sandaru"
