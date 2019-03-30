#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f "$EXECFILE" ]; then
	ln -s  /usr/bin/v2ray/v2ray $EXECFILE
fi
sleep 2

cat >> /etc/config.json<< TEMPEOF
{
    "log": {
        "access": "/dev/stdout",
        "error": "/dev/stdout",
        "loglevel": "warning"
    },
    "inbound": {
        "port": $PORT,
        "protocol": "vmess",
        "settings": {
            "udp": true,
            "clients": [
                {
                    "id": "$ID",
                    "level": 1,
                    "alterId": 233
                }
            ]
        }
    },
    "outbound": {
        "protocol": "freedom",
        "settings": {}
    }
}

TEMPEOF

sleep 2

LIMIT_PORT=$PORT
BURST=100kb
LATENCY=50ms
INTERVAL=60

iptables -F
iptables -A INPUT -p tcp -m state --state NEW --dport $LIMIT_PORT -m connlimit --connlimit-above $LIMIT_CONN -j DROP
tc qdisc add dev eth0 root tbf rate $RATE burst $BURST latency $LATENCY
# watch -n $INTERVAL tc -s qdisc ls dev eth0

get_ip() {
	ip=$(curl -s https://ipinfo.io/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.ip.sb/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.ipify.org)
	[[ -z $ip ]] && ip=$(curl -s https://ip.seeip.org)
	[[ -z $ip ]] && ip=$(curl -s https://ifconfig.co/ip)
	[[ -z $ip ]] && ip=$(curl -s https://api.myip.com | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	[[ -z $ip ]] && ip=$(curl -s icanhazip.com)
	[[ -z $ip ]] && ip=$(curl -s myip.ipip.net | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	[[ -z $ip ]] && echo -e "\n$red 这垃圾小鸡扔了吧！$none\n" && exit
}

get_ip

echo
echo "地址 (Address) = ${ip}"
echo
echo "端口 (Port) = $PORT"
echo
echo "用户ID (User ID / UUID) = ${ID}"
echo
echo "额外ID (Alter Id) = 233"
echo
echo "传输协议 (Network) = tcp"
echo
echo "伪装类型 (header type) = none"
echo

cat >/tmp/vmess_qr.json <<-EOF
{
			"v": "2",
			"ps": "sanjin_${ip}",
			"add": "${ip}",
			"port": "${PORT}",
			"id": "${ID}",
			"aid": "233",
			"net": "tcp",
			"type": "none",
			"host": "",
			"path": "",
			"tls": ""
}
EOF

vmess="vmess://$(cat /tmp/vmess_qr.json)"
echo
echo "---------- V2Ray vmess URL / V2RayNG v0.4.1+ / V2RayN v2.1+ / 仅适合部分客户端 -------------"
echo
echo -e $vmess
echo
rm -rf /tmp/vmess_qr.json

sleep 2
$EXECFILE -config=/etc/config.json

