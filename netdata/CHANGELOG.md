<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

[Click here to view the release notes of Netdata itself](https://github.com/netdata/netdata/releases).

### v2.5.1-addon.1

- Fix Netdata not resolving container names, fixes [#66](https://github.com/felipecrs/netdata-hass-addon/issues/66)
  - This works around a bug in Netdata itself, and I plan to upstream the fix at some point

### v2.5.1-addon.0

- Delete previous Netdata image versions on startup, fixes [#65](https://github.com/felipecrs/netdata-hass-addon/issues/65)
  - This is a workaround for a [bug](https://github.com/home-assistant/supervisor/issues/3223) in Home Assistant Supervisor
- Pull Netdata from GitHub Container Registry rather than from Docker Hub
  - Docker Hub has pull restrictions that GitHub Container Registry does not
