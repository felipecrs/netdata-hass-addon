FROM netdata/netdata:v1.45.6

# add-ons normally run as root
# hadolint ignore=DL3002
USER root

RUN --mount=type=bind,source=scripts/prepare_image.sh,target=/tmp/prepare_image.sh \
  exec /tmp/prepare_image.sh

COPY rootfs /

ENTRYPOINT ["/opt/netdata-hass-addon/run.sh"]
