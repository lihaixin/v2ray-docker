# USE for v2ray url
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html/
ENV CTIME     20181103
ENV HTTPDIR     /usr/share/nginx/html/
# ENV PORT 80
ENV V2RAYURL="c3M6Ly9ZMmhoWTJoaE1qQXRhV1YwWmkxd2IyeDVNVE13TlRvd01EQXdNREJBTWpBeUxqRTRNaTR4TURRdU5qbzJNVEE0TUE9PSMyMg=="
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

