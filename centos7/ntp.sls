{% set server_pool = salt['pillar.get']('ntp:pool_address', "centos.pool.ntp.org") %}

ntp:
  pkg.installed

ntp-conf:
  cmd.run:
    - name: sed -i "s/centos.pool.ntp.org/{{ server_pool }}/g" /etc/ntp.conf
    - onlyif: grep "centos.pool.ntp.org" /etc/ntp.conf > /dev/null
