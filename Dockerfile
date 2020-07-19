FROM ubuntu:latest as builder

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh

FROM alpine:latest

LABEL maintainer "Darian Raymond <admin@v2ray.com>"
LABEL VERSION v4.26.0
LABEL CTIME 2020-7-19

COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/


# COPY config.json /etc/v2ray/config.json

ENV TZ=Asia/Shanghai
ENV PATH /usr/bin/v2ray:$PATH
ENV SERVERIP 8.8.8.8
ENV PORT 59028
ENV LSPORT 1080
ENV LHPORT 8080
ENV ID 88888888-4444-4444-4444-121212121212 

ENV EXECFILE	/usr/sbin/httpv

RUN set -ex && \
    apk --no-cache add ca-certificates tzdata && \
    mkdir /var/log/v2ray/ &&\
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray



COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
