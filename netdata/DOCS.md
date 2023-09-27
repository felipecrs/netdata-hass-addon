# Home Assistant Add-on: Netdata

The [Netdata](https://www.netdata.cloud/) add-on for Home Assistant.

## Installation

Follow these steps to get the add-on installed on your system:

1. Click here:

   [![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Ffelipecrs%2Fnetdata-hass-addon)

1. Scroll down the page to find the new repository, and click in the new add-on named **_Netdata_**.
1. Click in the **_INSTALL_** button.

## Using

1. Disable _Protection Mode_.
1. Start the add-on.

## Configuring Netdata

The Netdata configuration files are located in `/config/netdata`. You can edit them directly.

**Note**: _Remember to restart the add-on when the Netdata configuration files are changed._

## Configuring the add-on

The add-on has some optional configurations that can be used to customize it.

**Note**: _Remember to restart the add-on when the configuration is changed._

### Option: `netdata_claim_url`

The Netdata Claim URL to use when connecting to the Netdata Cloud. The default is `https://app.netdata.cloud`, which is the official Netdata Cloud.

### Option: `netdata_claim_token`

The Netdata Claim Token to use when connecting to the Netdata Cloud. You can get yours on <https://app.netdata.cloud/>.

![First step](https://github.com/hassio-addons/addon-ssh/assets/29582865/97b28b92-14f5-4232-88d4-f305de45a922)
![Second step](https://github.com/hassio-addons/addon-ssh/assets/29582865/9dfd2b72-9e1f-4f3e-87a0-a6e7d3761c23)

### Option: `netdata_claim_rooms`

The Netdata Claim Rooms to use when connecting to the Netdata Cloud. You can get yours on <https://app.netdata.cloud/>.

![First step](https://github.com/hassio-addons/addon-ssh/assets/29582865/97b28b92-14f5-4232-88d4-f305de45a922)
![Second step](https://github.com/hassio-addons/addon-ssh/assets/29582865/7ce5bb97-903a-4778-8304-a2fa433c77b1)

### Option: `netdata_extra_apk_packages`

Installs extra packages using Alpine Linux's package manager. For example: `lm-sensors`. Refer to <https://learn.netdata.cloud/docs/installing/docker#adding-extra-packages-at-runtime>.

## Configuring the [Netdata integration](https://www.home-assistant.io/integrations/netdata/)

```yaml
# Example configuration.yaml entry
sensor:
  - platform: netdata
```

You do not need to configure `host`, `port`, or `name`. The defaults will work.

Read more on how to configure the Netdata integration [here](https://www.home-assistant.io/integrations/netdata/).
