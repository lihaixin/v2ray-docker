#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cd /usr/share/nginx/html/
echo "添加以V2RAYURL开头的变量增加节点"
echo "例如V2RAYURL_US1"
echo "详细使用方法请查看http://bit.ly/2HN3STj"
ALLURL=`env | grep V2RAYURL`
for c in $ALLURL
do
        echo $c | awk -F'vmess' -vOFS="vmess" '{$1="";$1=$1}1' >> url.txt
done
cat url.txt | base64 | xargs | sed 's/\s\+//g' | tee index.html >/dev/null
rm -rf  url.txt
nginx -g "daemon off;" >/dev/null
