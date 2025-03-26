<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

[Click here to view the release notes of Netdata itself](https://github.com/netdata/netdata/releases).

### 2.3.1-addon.1

- Hotfix for the add-on not being removed after stopping it
  - This reverts the `/host/sys/fs/cgroup` fix, which means cgroups metrics will no longer be shown
  - If you upgraded to `2.3.1-addon.0` before this hotfix, you will need to disable _Start on boot_, reboot the host, upgrade to `2.3.1-addon.1`, and then re-enable _Start on boot_

### 2.3.1-addon.0

- Fix several metrics not being shown because of `/host` mounts not working, including:
  - `/host/proc`
  - `/host/sys`
    - And submounts like `/host/sys/fs/cgroup`
  - `/host/etc/os-release`
  - `/host/etc/passwd`
  - `/host/etc/group`
  - `/host/etc/localtime` (newly added)
- Add `apcupsd` package to support [monitoring UPS devices](https://learn.netdata.cloud/docs/collecting-metrics/ups/apc-ups) out of the box

### 2.2.6-addon.3

- Remove `lm-sensors` package from the add-on, which is [no longer required by Netdata](https://community.netdata.cloud/t/temperature-on-raspberryi-pi-lm-sensors-deprecated/5910)

### 2.2.6-addon.2

- Add support for [monitoring NVME devices](https://learn.netdata.cloud/docs/collecting-metrics/storage,-mount-points-and-filesystems/nvme-devices) out of the box

### 2.2.6-addon.1

- Add support for [monitoring storage devices through S.M.A.R.T.](https://learn.netdata.cloud/docs/collecting-metrics/hardware-devices-and-sensors/s.m.a.r.t.) out of the box

### 2.2.6-addon.0

- Migrate Netdata configuration files out of Home Assistant config directory
  - This ensures the add-on backup and restore includes the Netdata configuration files
