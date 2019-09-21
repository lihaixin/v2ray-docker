FROM ubuntu:latest as builder

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh

FROM alpine:latest

LABEL maintainer "lEE <admin@v2ray.com>"
LABEL VERSION v4.20
LABEL CTIME 2019-9-21

ENV PORT 59028
ENV ID="36cc0413-0620-4ff7-b92d-6b99bd6c91d3"
ENV DOMAIN=""
ENV REMARKS="us21"
ENV LIMIT_CONN=100
ENV RATE=30mbit
ENV EXECFILE=/usr/sbin/httpv
ENV MTU=1350
ENV TTI=70
ENV BufferSize=3


RUN apk add -U iproute2 tzdata curl && ln -s /usr/lib/tc /lib/tc \
         && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/

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
