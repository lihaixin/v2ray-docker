#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cd /usr/share/nginx/html/
echo "添加以V2RAYURL开头的变量增加节点"
echo "例如V2RAYURL_US1"
ALLURL=`env | grep A2RAYURL`
for c in $ALLURL
do
        echo $c | awk -F'vmess' -vOFS="vmess" '{$1="";$1=$1}1' >> url.txt
done
echo url.txt | base64 | xargs | sed 's/\s\+//g' | tee index.html
rm -rf  url.txt
nginx -g "daemon off;"
