# USE for client down
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html/
ENV CTIME     20200719
ENV HTTPDIR     /usr/share/nginx/html/

#Down client file
#windows
ADD https://github.com/2dust/v2rayN/releases/download/3.19/v2rayN-Core.zip ${HTTPDIR}

#Mac ios
ADD https://github.com/Cenmrev/V2RayX/releases/download/v1.5.1/V2RayX.app.zip ${HTTPDIR}
#iPhone 
ADD https://github.com/t0m1tu/ssr-backup/raw/master/Shadowrocket-2.1.10-PP.ipa ${HTTPDIR}
#android
ADD https://github.com/2dust/v2rayNG/releases/download/1.2.14/v2rayNG_1.2.14_arm64-v8a.apk ${HTTPDIR}
ADD https://github.com/2dust/v2rayNG/releases/download/1.2.14/v2rayNG_1.2.14_armeabi-v7a.apk ${HTTPDIR}
ADD https://github.com/2dust/v2rayNG/releases/download/1.2.14/v2rayNG_1.2.14.apk ${HTTPDIR}
#chrome
ADD https://github.com/FelisCatus/SwitchyOmega/releases/download/v2.5.20/SwitchyOmega_Chromium.crx ${HTTPDIR} 
ADD https://github.com/FelisCatus/SwitchyOmega/releases/download/v2.5.20/proxy_switchyomega-2.5.20-an+fx.xpi ${HTTPDIR} 
#doc
ADD https://docs.google.com/document/export?format=html&id=1dbiYopOldjDig8rTNellMQwzqYQiSev_Z5pwyrnQMVk ${HTTPDIR}
ADD ./index.html /usr/share/nginx/html/
RUN mv export v2ray使用指南.html && chmod 644 ./*

CMD ["nginx", "-g", "daemon off;"]
