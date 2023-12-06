FROM netdata/netdata:v1.44.0

USER root

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends gnupg && \
  install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
  apt-get purge -y --auto-remove gnupg && \
  chmod a+r /etc/apt/keyrings/docker.gpg && \
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends lm-sensors docker-ce-cli && \
  rm -rf /var/lib/apt/lists/*

COPY rootfs /

ENTRYPOINT ["/run.sh"]
