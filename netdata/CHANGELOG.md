<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

[Click here to view the Netdata changelog](https://github.com/netdata/netdata/releases).

### 2.2.6-addon.1

- Add support for monitoring [S.M.A.R.T.](https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology) through [smartctl](https://learn.netdata.cloud/docs/collecting-metrics/hardware-devices-and-sensors/s.m.a.r.t.) out of the box
- Improve addon installation and update time a little bit, by avoiding depending on `gpg` and by removing one of the `apt-get update` calls

### 2.2.6-addon.0

- Migrate Netdata configuration files out of Home Assistant config directory
  - This ensures the add-on backup and restore includes the Netdata configuration files
