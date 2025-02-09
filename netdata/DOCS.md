# Home Assistant Add-on: Netdata

_Monitor your servers, containers, and applications, in high-resolution and in
real-time._

Learn more about Netdata at their
[official website](https://www.netdata.cloud/).

![Netdata Home Assistant add-on](https://github.com/felipecrs/netdata-hass-addon/assets/29582865/535dcb73-c556-4369-aadd-a2d32425b83c)

## Installation

Follow these steps to get the add-on installed on your system:

1. Click here:

   [![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Ffelipecrs%2Fnetdata-hass-addon)

1. Scroll down the page to find the new repository, and click in the new add-on
   named **_Netdata_**.
1. Click in the **_INSTALL_** button.

## Using

1. Disable _Protection Mode_.
1. Start the add-on.

## Configuring Netdata

The Netdata configuration files are located in `/config/netdata`. You can edit
them directly.

If you are using the _Advanced SSH & Web Terminal_ add-on with protection mode
disabled, you can use the `edit-config` helper directly. Example:

```console
docker exec -it -w /etc/netdata addon_bc277197_netdata ./edit-config charts.d.conf
```

**Note**: _Remember to restart the add-on when the Netdata configuration files
are changed._

## Configuring the add-on

The add-on has some optional configurations that can be used to customize it.

**Note**: _Remember to restart the add-on when the configuration is changed._

### Option: `netdata_claim_url`

The Netdata Claim URL to use when connecting to the Netdata Cloud. The default
is `https://app.netdata.cloud`, which is the official Netdata Cloud.

### Option: `netdata_claim_token`

The Netdata Claim Token to use when connecting to the Netdata Cloud. You can get
yours on <https://app.netdata.cloud/>.

![First step](https://github.com/hassio-addons/addon-ssh/assets/29582865/97b28b92-14f5-4232-88d4-f305de45a922)
![Second step](https://github.com/hassio-addons/addon-ssh/assets/29582865/9dfd2b72-9e1f-4f3e-87a0-a6e7d3761c23)

### Option: `netdata_claim_rooms`

The Netdata Claim Rooms to use when connecting to the Netdata Cloud. You can get
yours on <https://app.netdata.cloud/>.

![First step](https://github.com/hassio-addons/addon-ssh/assets/29582865/97b28b92-14f5-4232-88d4-f305de45a922)
![Second step](https://github.com/hassio-addons/addon-ssh/assets/29582865/7ce5bb97-903a-4778-8304-a2fa433c77b1)

### Option: `netdata_extra_deb_packages`

Installs extra packages using Debian's package manager. For example: `apcupsd`.
Refer to
<https://learn.netdata.cloud/docs/installing/docker#adding-extra-packages-at-runtime>.

Note that `lm-sensors` comes preinstalled already.

### Option: `netdata_healthcheck_target`

Allows to control how the docker health checks from Netdata run. For example: `cli`.
Refer to
<https://learn.netdata.cloud/docs/installing/docker#health-checks>.

## Signing-in to Netdata Cloud from within the add-on

When opening the Netdata web interface, you'll be prompted to sign-in to Netdata Cloud.

**There's no need to do that**, and you can just click _Skip and use the dashboard anonymously_ instead.

Unfortunately, [Netdata v2 provides no option to disable such annoyance](https://github.com/netdata/netdata/issues/18964).

The sign-in functionality will not work when accessing the Netdata interface through the Home Assistant interface.

However, the add-on also exposes the Netdata web interface on port `19999`, which you can access from your browser:

```
http://<HA IP address>:19999
```

And the sign-in button will work there.

## Configuring the [Netdata integration](https://www.home-assistant.io/integrations/netdata/)

```yaml
# Example configuration.yaml entry
sensor:
  - platform: netdata
```

You do not need to configure `host`, `port`, or `name`. The defaults will work.

Read more on how to configure the Netdata integration
[here](https://www.home-assistant.io/integrations/netdata/).
