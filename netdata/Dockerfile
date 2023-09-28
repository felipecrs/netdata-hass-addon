FROM netdata/netdata:v1.42.4

USER root

RUN apk add --no-cache lm-sensors docker-cli

COPY rootfs /

ENTRYPOINT ["/run.sh"]
