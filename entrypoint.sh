#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cd /usr/share/nginx/html/
#echo $V2RAYURL | tr ' ' '\n' | base64 | tee index.html
echo $V2RAYURL > index.html
nginx -g "daemon off;"
