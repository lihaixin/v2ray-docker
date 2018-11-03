# USE for v2ray url
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html/
ENV CTIME     20181103
ENV HTTPDIR     /usr/share/nginx/html/
# ENV PORT 80
ENV V2RAYURL="ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTowMDAwMDBAMjAyLjE4Mi4xMDQuNjo2MTA4MA==#22"
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

