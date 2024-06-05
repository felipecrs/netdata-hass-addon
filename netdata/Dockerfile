FROM netdata/netdata:v1.45.6

# add-ons normally run as root
# hadolint ignore=DL3002
USER root

COPY rootfs /

# prepare_image.sh could have been mounted with --mount, but HAOS apparently
# doesn't use buildkit
RUN ["/opt/netdata-hass-addon/prepare_image.sh"]

ENTRYPOINT ["/opt/netdata-hass-addon/run.sh"]
