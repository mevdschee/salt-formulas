{% set timezone = salt['pillar.get']('timezone:location', "UTC") %}

timezone:
  file.managed:
    - name: /etc/timezone
    - contents: {{ timezone }}

timezone_localtime:
  file.symlink:
    - name: /etc/localtime
    - target: /usr/share/zoneinfo/{{ timezone }}
    - force: true

