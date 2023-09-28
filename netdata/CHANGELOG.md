<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

This add-on follows Netdata's versioning. The changelog for Netdata can be found [here](https://github.com/netdata/netdata/blob/master/CHANGELOG.md)

## Unreleased

- Mount `/proc`, `/sys`, `/etc/os-release`, `/etc/passwd`, `/etc/group` as read-only as recommended by the [official Netdata documentation](https://learn.netdata.cloud/docs/installing/docker#recommended-way)

## 1.42.4-1

- Change panel icon to `mdi:icon`
- Fix `netdata_extra_apk_packages` not working

## 1.42.4

- Initial release based on Netdata v1.42.4
