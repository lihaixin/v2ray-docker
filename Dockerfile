# USE for client down
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html/

#RUN brook_new_ver=`wget -qO- https://github.com/txthinking/brook/tags| grep "/txthinking/brook/releases/tag/"| head -n 1| awk -F "/tag/" '{print $2}'| sed 's/\">//'` && \
ENV VERSION	v20180401
ENV HTTPDIR     /usr/share/nginx/html/



#Down client file
##windows
ADD https://github.com/v2ray/v2ray-core/releases/download/v3.31/v2ray-windows-32.zip ${HTTPDIR}
ADD https://github.com/v2ray/v2ray-core/releases/download/v3.31/v2ray-windows-64.zip ${HTTPDIR}
ADD https://github.com/2dust/v2rayN/releases/download/2.11/v2rayN.exe ${HTTPDIR}
#Mac ios
ADD https://github.com/Cenmrev/V2RayX/releases/download/v1.2.1/V2RayX.app.zip ${HTTPDIR}
#android
ADD https://github.com/2dust/v2rayNG/releases/download/0.5.1/app-arm64-v8a-release.apk ${HTTPDIR}
ADD https://github.com/2dust/v2rayNG/releases/download/0.5.1/app-armeabi-v7a-release.apk ${HTTPDIR}
ADD https://github.com/2dust/v2rayNG/releases/download/0.5.1/app-universal-release.apk ${HTTPDIR}
#chrome
ADD https://github.com/FelisCatus/SwitchyOmega/releases/download/v2.5.16/SwitchyOmega-Chromium-2.5.15.crx ${HTTPDIR} 
ADD https://github.com/FelisCatus/SwitchyOmega/releases/download/v2.5.16/proxy_switchyomega-2.5.16-an.fx.xpi ${HTTPDIR} 
#doc
ADD https://docs.google.com/document/export?format=pdf&id=1dbiYopOldjDig8rTNellMQwzqYQiSev_Z5pwyrnQMVk ${HTTPDIR}
ADD ./index.html /usr/share/nginx/html/
RUN mv export v2ray使用指南.pdf && chmod 644 ./*

CMD ["nginx", "-g", "daemon off;"]
