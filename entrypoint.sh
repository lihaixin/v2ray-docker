#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cd /usr/share/nginx/html/
echo $V2RAYURL | base64 | xargs | sed 's/\s\+//g' | tee index.html
echo $V2RAYURL > index.html
nginx -g "daemon off;"
