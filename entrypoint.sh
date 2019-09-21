#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f "$EXECFILE" ]; then
	ln -s  /usr/bin/v2ray/v2ray $EXECFILE
fi

sleep 2

get_ip() {
	ip=$DOMAIN
	[[ -z $ip ]] && ip=$(curl -s https://ipinfo.io/ip)
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

get_envs() {
        [[ -z $ID ]] && ID=$(cat /proc/sys/kernel/random/uuid)
	[[ -z $REMARKS ]] && REMARKS=sanjin
}

get_envs


cat > /etc/config.json<< TEMPEOF
{
   "outbound": {
     "protocol": "freedom"
   },
   "log": {
        "access": "/dev/stdout",
        "error": "/dev/stdout",
        "loglevel": "warning"
   },
   "outboundDetour": [
     {
       "protocol": "blackhole",
       "tag": "blocked"
     }
   ],
   "inbound": {
     "settings": {
       "clients": [
         {
           "id": "$ID",
           "level": 1,
           "alterId": 233
         }
       ]
     },
     "port": $PORT,
     "protocol": "vmess",
     "streamSettings": {
       "network": "mkcp",
       "kcpSettings": {
         "readBufferSize": $BufferSize,
         "uplinkCapacity": $RATE,
         "header": {
           "type": "utp"
         },
         "mtu": $MTU,
         "writeBufferSize": $BufferSize,
         "congestion": true,
         "downlinkCapacity": $RATE,
         "tti": $TTI
       },
       "security": "none"
     }
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



echo
echo "---------- V2Ray 配置信息 -------------"
echo "地址 (Address) = ${ip}"
echo
echo "端口 (Port) = $PORT"
echo
echo "用户ID (User ID / UUID) = ${ID}"
echo
echo "额外ID (Alter Id) = 233"
echo
echo "传输协议 (Network) = kcp"
echo
echo "伪装类型 (header type) = utp"
echo
echo "传输速度 (speed) = $RATE"
echo
echo "最大传输单元 (mtu) = $MTI"
echo
echo "传输时间间隔(tti) = $TTI"
echo 
echo "是否启用拥塞控制(congestion) = true"
echo "---------- END -------------"
echo

cat >/tmp/vmess_qr.json <<-EOF
{
			"v": "2",
			"ps": "${REMARKS}",
			"add": "${ip}",
			"port": "${PORT}",
			"id": "${ID}",
			"aid": "233",
			"net": "kcp",
			"type": "utp",
			"host": "",
			"path": "",
			"tls": ""
}
EOF

url_create() {
	vmess="vmess://$(cat /tmp/vmess_qr.json | base64 | xargs | sed 's/\s\+//g')"
	echo
	echo "---------- V2Ray vmess URL / V2RayNG v0.4.1+ / V2RayN v2.1+ / 仅适合部分客户端 -------------"
	echo
	echo -e $vmess
	echo
}

url_create

qr_create() {
	#vmess="vmess://$(cat /tmp/vmess_qr.json | base64)"
	link="https://233boy.github.io/tools/qr.html#vmess://$(cat /tmp/vmess_qr.json | base64 | xargs | sed 's/\s\+//g')"
	echo
	echo "---------- V2Ray 二维码链接 适用于 V2RayNG v0.4.1+ / Kitsunebi -------------"
	echo
	echo -e $link
	echo
	echo
	echo -e "友情提醒: 请务必核对扫码结果 (V2RayNG 除外)"
	echo
	echo
	echo " V2Ray 客户端使用教程: http://bit.ly/2HN3STj"
	echo
	echo
}

qr_create

rm -rf /tmp/vmess_qr.json

sleep 2
$EXECFILE -config=/etc/config.json

