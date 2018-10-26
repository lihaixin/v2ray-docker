FROM alpine:latest

LABEL maintainer "lEE <admin@v2ray.com>"
LABEL VERSION v3.18.1
LABEL CTIME 2018-4-22

ENV PORT 59028
ENV ID 88888888-4444-4444-4444-121212121212 
ENV LIMIT_CONN 100
ENV RATE 500mbit
ENV EXECFILE	/usr/sbin/httpv

RUN apk add -U iproute2 tzdata && ln -s /usr/lib/tc /lib/tc \
         && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime

ADD https://storage.googleapis.com/v2ray-docker/v2ray /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/v2ctl /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geoip.dat /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geosite.dat /usr/bin/v2ray/

# COPY config.json /etc/v2ray/config.json

RUN set -ex && \
    apk --no-cache add ca-certificates && \
    mkdir /var/log/v2ray/ &&\
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray

# ENV PATH /usr/bin/v2ray:$PATH

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
