{% set timezone = salt['pillar.get']('timezone:location', "UTC") %}

timezone:
  file.symlink:
    - name: /etc/localtime
    - target: /usr/share/zoneinfo/{{ timezone }}
    - force: true
