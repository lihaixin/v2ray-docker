#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f "$EXECFILE" ]; then
	ln -s  /usr/bin/v2ray/v2ray $EXECFILE
fi
sleep 2

cat > /etc/config.json<< TEMPEOF
{
    "log": {
        "access": "/dev/stdout",
        "error": "/dev/stdout",
        "loglevel": "warning"
    },
    "outbounds": [
        {
            "protocol": "vmess",
            "settings": {
                "vnext": [
                    {
                        "address": "$SERVERIP",
                        "port": $PORT,
                        "users": [
                            {
                                "id": "$ID",
                                "alterId": 233,
                                "security": "auto"
                            }
                        ]
                    }
                ]
            },
            "mux": {
                "enabled": true
            }
        },
        {
            "protocol": "freedom",
            "settings": {},
            "tag": "direct"
        }
    ],
    "inbounds": [
        {
            "port": $LSPORT,
            "listen": "0.0.0.0",
            "protocol": "socks",
            "settings": {
                "auth": "noauth",
                "udp": true,
                "ip": "127.0.0.1"
            }
        },
        {
            "port": $LHPORT,
            "listen": "0.0.0.0",
            "protocol": "http",
            "settings": {
                "auth": "noauth",
                "udp": true,
                "ip": "127.0.0.1"
            }
        }
    ],
    "dns": {
        "servers": [
            "8.8.8.8",
            "8.8.4.4",
            "localhost"
        ]
    }
}
TEMPEOF

sleep 2

$EXECFILE -config=/etc/config.json

