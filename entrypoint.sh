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

$EXECFILE -config=/etc/config.json

