<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

# Changelog

[Read the Netdata release notes](https://github.com/netdata/netdata/releases)

## 2.8.5-addon.2

- Fix when Docker Daemon is running with the containerd-snapshotter
  - It's the case for new installations of [Home Assistant OS 17](https://github.com/home-assistant/operating-system/releases/tag/17.0) and later, or those who migrated manually

## 2.8.5-addon.1

- Remove the workaround for deleting old Netdata images on startup
  - Which is no longer necessary since Home Assistant Supervisor 2025.07.0

## 2.8.5-addon.0

- Remove armhf, armv7, and i386 architectures, as they are no longer supported by Home Assistant

## 2.6.0-addon.0

- Remove workaround for Netdata not resolving container names, as it was fixed in Netdata v2.6.0

## 2.5.4-addon.2

- Revert the _Fail on initialization if Watchdog is not enabled_ change, which was not necessary after all

## 2.5.4-addon.1

- Fix the cleanup old Netdata images operation causing the add-on to fail on initialization if there was nothing to clean up
- Fail on initialization if _Watchdog_ is not enabled
- Revert the _Add a timeout for the cleanup old Netdata images operation_ change, which was not necessary after all

## 2.5.4-addon.0

- Add a timeout for the cleanup old Netdata images operation to avoid blocking the add-on startup indefinitely

## 2.5.2-addon.0

- Fix Netdata version still in 2.5.1

## 2.5.1-addon.3

- Add check for when _Protection mode_ was not disabled
- Avoid cleaning up Netdata images on initialization twice (before and after setting up the `/host` mounts)
- Improve logs with fewer debug messages and more descriptive messages

## 2.5.1-addon.2

- Remove dependency on Docker CLI
  - This makes the installation and update of the add-on considerably faster
  - And allowed to remove part of the workaround introduced in the last version, as realized [in this issue comment](https://github.com/netdata/netdata/pull/20283#issuecomment-2881491522).

## 2.5.1-addon.1

- Fix Netdata not resolving container names, fixes [#66](https://github.com/felipecrs/netdata-hass-addon/issues/66)
  - This works around a bug in Netdata itself, and I plan to upstream the fix at some point

## 2.5.1-addon.0

- Delete previous Netdata image versions on startup, fixes [#65](https://github.com/felipecrs/netdata-hass-addon/issues/65)
  - This is a workaround for a [bug](https://github.com/home-assistant/supervisor/issues/3223) in Home Assistant Supervisor
- Pull Netdata from GitHub Container Registry rather than from Docker Hub
  - Docker Hub has pull restrictions that GitHub Container Registry does not

## 2.3.1-addon.2

- Fix cgroup metrics not showing because of `/host/sys/fs/cgroup` mount not working

## 2.3.1-addon.1

- Hotfix for the add-on not being removed after stopping it
  - This reverts the `/host/sys/fs/cgroup` fix, which means cgroups metrics will no longer be shown
  - If you upgraded to `2.3.1-addon.0` before this hotfix, you will need to disable _Start on boot_, reboot the host, upgrade to `2.3.1-addon.1`, and then re-enable _Start on boot_

## 2.3.1-addon.0

- Fix several metrics not being shown because of `/host` mounts not working, including:
  - `/host/proc`
  - `/host/sys`
    - And submounts like `/host/sys/fs/cgroup`
  - `/host/etc/os-release`
  - `/host/etc/passwd`
  - `/host/etc/group`
  - `/host/etc/localtime` (newly added)
- Add `apcupsd` package to support [monitoring UPS devices](https://learn.netdata.cloud/docs/collecting-metrics/ups/apc-ups) out of the box

## 2.2.6-addon.3

- Remove `lm-sensors` package from the add-on, which is [no longer required by Netdata](https://community.netdata.cloud/t/temperature-on-raspberryi-pi-lm-sensors-deprecated/5910)

## 2.2.6-addon.2

- Add support for [monitoring NVME devices](https://learn.netdata.cloud/docs/collecting-metrics/storage,-mount-points-and-filesystems/nvme-devices) out of the box

## 2.2.6-addon.1

- Add support for [monitoring storage devices through S.M.A.R.T.](https://learn.netdata.cloud/docs/collecting-metrics/hardware-devices-and-sensors/s.m.a.r.t.) out of the box

## 2.2.6-addon.0

- Migrate Netdata configuration files out of Home Assistant config directory
  - This ensures the add-on backup and restore includes the Netdata configuration files

## 1.44.1-addon.1

- Fix `netdata_healthcheck_target` option not working.

## 1.44.1-addon.0

- Add `netdata_healthcheck_target` configuration (#7) by @plasticrake.

## 1.44.0-addon.0

- The Netdata docker image is now based on Debian to allow monitoring of logs
  with systemd and journald. Changes have been made to the add-on to accomodate
  and support these new features.
- The option `netdata_extra_apk_packages` was renamed to
  `netdata_extra_deb_packages`, make sure to add your packages from
  `netdata_extra_apk_packages` back to it as it will come empty by default after
  upgrading.
- Mount `/var/log` and `/run/dbus` as read-only as recommended by the new
  [official Netdata documentation](https://learn.netdata.cloud/docs/installing/docker#recommended-way)

## 1.42.4-addon.1

- Mount `/proc`, `/sys`, `/etc/os-release`, `/etc/passwd`, `/etc/group` as
  read-only as recommended by the
  [official Netdata documentation](https://learn.netdata.cloud/docs/installing/docker#recommended-way)
- Preinstall `lm-sensors` without the need for `netdata_extra_apk_packages`

## 1.42.4-addon.0

- Change panel icon to `mdi:icon`

## 1.42.4

- Initial release based on Netdata 1.42.4
