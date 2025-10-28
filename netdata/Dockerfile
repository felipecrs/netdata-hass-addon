FROM ghcr.io/netdata/netdata:v2.7.3

# add-ons normally run as root
# hadolint ignore=DL3002
USER root

# this could have been done with RUN --mount, but HAOS doesn't use buildkit
COPY rootfs/opt/netdata-hass-addon/prepare_image.sh rootfs/opt/netdata-hass-addon/common.bash /opt/netdata-hass-addon/
RUN ["/opt/netdata-hass-addon/prepare_image.sh"]

COPY rootfs /

ENTRYPOINT ["/opt/netdata-hass-addon/run.sh"]
