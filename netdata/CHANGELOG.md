<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

This add-on follows Netdata's versioning. The changelog for Netdata can be found
[here](https://github.com/netdata/netdata/blob/master/CHANGELOG.md)

If the version you are looking for is not in this list, it means no changes were
made to the add-on itself in such version.

## 1.44.1-1

- Fix `netdata_healthcheck_target` option not working.

## 1.44.1-0

- Add `netdata_healthcheck_target` configuration (#7) by @plasticrake.

## 1.44.0

- The Netdata docker image is now based on Debian to allow monitoring of logs
  with systemd and journald. Changes have been made to the add-on to accomodate
  and support these new features.
- The option `netdata_extra_apk_packages` was renamed to
  `netdata_extra_deb_packages`, make sure to add your packages from
  `netdata_extra_apk_packages` back to it as it will come empty by default after
  upgrading.
- Mount `/var/log` and `/run/dbus` as read-only as recommended by the new
  [official Netdata documentation](https://learn.netdata.cloud/docs/installing/docker#recommended-way)

## 1.42.4-2

- Mount `/proc`, `/sys`, `/etc/os-release`, `/etc/passwd`, `/etc/group` as
  read-only as recommended by the
  [official Netdata documentation](https://learn.netdata.cloud/docs/installing/docker#recommended-way)
- Preinstall `lm-sensors` without the need for `netdata_extra_apk_packages`

## 1.42.4-1

- Change panel icon to `mdi:icon`
- Fix `netdata_extra_apk_packages` not working
