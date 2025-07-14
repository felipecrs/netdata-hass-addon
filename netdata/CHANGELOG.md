<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

[Click here to view the release notes of Netdata itself](https://github.com/netdata/netdata/releases).

### v2.5.4-addon.0

- Add a timeout for the cleanup old Netdata images operation to avoid blocking the add-on startup indefinitely

### v2.5.2-addon.0

- Fix Netdata version still in 2.5.1

### v2.5.1-addon.3

- Add check for when _Protection mode_ was not disabled
- Avoid cleaning up Netdata images on initialization twice (before and after setting up the `/host` mounts)
- Improve logs with fewer debug messages and more descriptive messages

### v2.5.1-addon.2

- Remove dependency on Docker CLI
  - This makes the installation and update of the add-on considerably faster
  - And allowed to remove part of the workaround introduced in the last version, as realized [here](https://github.com/netdata/netdata/pull/20283#issuecomment-2881491522).

### v2.5.1-addon.1

- Fix Netdata not resolving container names, fixes [#66](https://github.com/felipecrs/netdata-hass-addon/issues/66)
  - This works around a bug in Netdata itself, and I plan to upstream the fix at some point

### v2.5.1-addon.0

- Delete previous Netdata image versions on startup, fixes [#65](https://github.com/felipecrs/netdata-hass-addon/issues/65)
  - This is a workaround for a [bug](https://github.com/home-assistant/supervisor/issues/3223) in Home Assistant Supervisor
- Pull Netdata from GitHub Container Registry rather than from Docker Hub
  - Docker Hub has pull restrictions that GitHub Container Registry does not
