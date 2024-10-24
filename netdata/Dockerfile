FROM netdata/netdata:v1.47.5

# add-ons normally run as root
# hadolint ignore=DL3002
USER root

# prepare_image.sh could have been mounted with --mount, but HAOS apparently
# doesn't use buildkit
COPY rootfs/opt/netdata-hass-addon/prepare_image.sh /opt/netdata-hass-addon/
RUN ["/opt/netdata-hass-addon/prepare_image.sh"]

COPY rootfs /

ENTRYPOINT ["/opt/netdata-hass-addon/run.sh"]
