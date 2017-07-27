{% set server_pool = salt['pillar.get']('ntp:pool_address', "ubuntu.pool.ntp.org") %}

ntp:
  pkg.installed

ntp-conf:
  cmd.run:
    - name: sed -i "s/ubuntu.pool.ntp.org/{{ server_pool }}/g" /etc/ntp.conf
    - onlyif: grep "ubuntu.pool.ntp.org" /etc/ntp.conf > /dev/null
