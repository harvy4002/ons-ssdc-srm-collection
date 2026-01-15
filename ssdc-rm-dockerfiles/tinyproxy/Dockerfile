#
# Dockerfile for tinyproxy
#

FROM alpine:3
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
RUN apk update && apk add --no-cache tinyproxy=1.11.2-r0
VOLUME /etc/tinyproxy
EXPOSE 8888
CMD ["tinyproxy", "-d"]
