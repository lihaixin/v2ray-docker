# USE for client down
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html/
ENV CTIME     20180721
ENV HTTPDIR     /usr/share/nginx/html/
ENV V2RAYURL="c3M6Ly9ZMmhoWTJoaE1qQXRhV1YwWmkxd2IyeDVNVE13TlRvd01EQXdNREJBTWpBeUxqRTRNaTR4TURRdU5qbzJNVEE0TUE9PSMyMg=="
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 80/tcp
ENTRYPOINT ["/entrypoint.sh"]

