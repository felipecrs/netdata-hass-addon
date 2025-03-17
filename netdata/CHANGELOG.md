<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

[Click here to view the Netdata changelog](https://github.com/netdata/netdata/releases).

### 2.2.6-addon.2

- Add support for [monitoring NVME devices](https://learn.netdata.cloud/docs/collecting-metrics/storage,-mount-points-and-filesystems/nvme-devices) out of the box

### 2.2.6-addon.1

- Add support for [monitoring storage devices through S.M.A.R.T.](https://learn.netdata.cloud/docs/collecting-metrics/hardware-devices-and-sensors/s.m.a.r.t.) out of the box

### 2.2.6-addon.0

- Migrate Netdata configuration files out of Home Assistant config directory
  - This ensures the add-on backup and restore includes the Netdata configuration files
