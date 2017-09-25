 Example pillar
#
#postgresql:
#  postgres_password: some_secure_password_change_me
#  encoding: UTF8
#  locale: en_US.UTF-8

{% set password = salt['pillar.get']('postgresql:postgres_password', '') %}
{% set encoding = salt['pillar.get']('postgresql:encoding', 'UTF8') %}
{% set locale = salt['pillar.get']('postgresql:locale', 'en_US.UTF8') %}

# set default_shared_buffers to 30% of the RAM
{% set default_shared_buffers = salt['cmd.run']('expr ' ~ salt['cmd.shell']('free -m | grep Mem: | sed -re "s/\s+/,/g" | cut -d, -f2') ~ ' \* 3 \/ 10') ~ 'MB' %}

# set default_effective_cache_size to 50% of the RAM
{% set default_effective_cache_size = salt['cmd.run']('expr ' ~ salt['cmd.shell']('free -m | grep Mem: | sed -re "s/\s+/,/g" | cut -d, -f2') ~ ' \* 5 \/ 10') ~ 'MB' %}

# set default_work_mem to 0.2% of the RAM (20% RAM for 100 connections))
{% set default_work_mem = salt['cmd.run']('expr ' ~ salt['cmd.shell']('free -m | grep Mem: | sed -re "s/\s+/,/g" | cut -d, -f2') ~ ' \* 2 \/ 1000') ~ 'MB' %}

# set default_maintenance_work_mem to 2% of the RAM (10 x work_mem)
{% set default_maintenance_work_mem = salt['cmd.run']('expr ' ~ salt['cmd.shell']('free -m | grep Mem: | sed -re "s/\s+/,/g" | cut -d, -f2') ~ ' \* 2 \/ 100') ~ 'MB' %}

{% set shared_buffers = salt['pillar.get']('postgresql:shared_buffers', default_shared_buffers) %}
{% set effective_cache_size = salt['pillar.get']('postgresql:effective_cache_size', default_effective_cache_size) %}
{% set checkpoint_segments = salt['pillar.get']('postgresql:checkpoint_segments', '64') %}
{% set default_statistics_target = salt['pillar.get']('postgresql:default_statistics_target', '250') %}
{% set work_mem = salt['pillar.get']('postgresql:work_mem', default_work_mem) %}
{% set maintenance_work_mem = salt['pillar.get']('postgresql:maintenance_work_mem', default_maintenance_work_mem) %}
{% set synchronous_commit = salt['pillar.get']('postgresql:synchronous_commit', 'off') %}

postgresql-package:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-client

postgresql-service:
  service.running:
    - name: postgresql
    - enable: True

postgresql-set-password:
  cmd.run:
    - name: echo "ALTER USER postgres WITH PASSWORD '{{ password }}';" | su - postgres -c psql
    - unless: echo "\du" | PGPASSWORD={{ password }} psql -Upostgres -h127.0.0.1 | grep postgres

postgresql-conf:
  ini.options_present:
    - name: '/var/lib/pgsql/data/postgresql.conf'
    - separator: '='
    - sections:
        shared_buffers: {{ shared_buffers }}
        effective_cache_size: {{ effective_cache_size }}
        checkpoint_segments: {{ checkpoint_segments }}
        default_statistics_target: {{ default_statistics_target }}
        work_mem: {{ work_mem }}
        maintenance_work_mem: {{ maintenance_work_mem }}
        synchronous_commit: {{ synchronous_commit }}

postgresql-systemd-directory:
  file.directory:
    - name: /etc/systemd/system/postgresql.service.d
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

postgresql-systemd-config:
  file.managed:
    - name: /etc/systemd/system/postgresql.service.d/limits.conf
    - user: root
    - group: root
    - mode: 644
    - contents: |
        [Service]
        LimitNOFILE=10000


