<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

This add-on follows Netdata's versioning. The changelog for Netdata can be found [here](https://github.com/netdata/netdata/blob/master/CHANGELOG.md)

If the version you are looking for is not in this list, it means no changes were made to the add-on itself in such version.

## 1.42.4-2

- Mount `/proc`, `/sys`, `/etc/os-release`, `/etc/passwd`, `/etc/group` as read-only as recommended by the [official Netdata documentation](https://learn.netdata.cloud/docs/installing/docker#recommended-way)
- Preinstall `lm-sensors` without the need for `netdata_extra_apk_packages`

## 1.42.4-1

- Change panel icon to `mdi:icon`
- Fix `netdata_extra_apk_packages` not working
