FROM netdata/netdata:v1.43.0

USER root

RUN apk add --no-cache lm-sensors docker-cli

COPY rootfs /

ENTRYPOINT ["/run.sh"]
