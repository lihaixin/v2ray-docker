# USE for v2ray url
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html/
ENV CTIME     20181103
ENV HTTPDIR     /usr/share/nginx/html/
ENV V2RAYURL="vmess://ewoidiI6ICIyIiwKInBzIjogInNhbmppbl80NS4zMi43NS42MSIsCiJhZGQiOiAiNDUuMzIuNzUuNjEiLAoicG9ydCI6ICI1OTAyOCIsCiJpZCI6ICI4ODg4ODg4OC00NDQ0LTQ0NDQtNDQ0NC0xMjEyMTIxMjEyMTIiLAoiYWlkIjogIjIzMyIsCiJuZXQiOiAidGNwIiwKInR5cGUiOiAibm9uZSIsCiJob3N0IjogIiIsCiJwYXRoIjogIiIsCiJ0bHMiOiAiIgp9Cg=="
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80/tcp
ENTRYPOINT ["/entrypoint.sh"]

