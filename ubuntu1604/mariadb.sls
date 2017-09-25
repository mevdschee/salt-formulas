# Example pillar
#
#mariadb:
#    root_password: some_secure_password_change_me

{% set password = salt['pillar.get']('mariadb:root_password', '') %}

# set default_innodb_buffer_pool_size to 70% of the RAM
{% set default_innodb_buffer_pool_size   = salt['cmd.run']('expr ' ~ salt['cmd.shell']('free -m | grep Mem: | sed -re "s/\s+/,/g" | cut -d, -f2') ~ ' \* 7 \/ 10') ~ 'M' %}

# set default_innodb_thread_concurrency to twice the core count
{% set default_innodb_thread_concurrency = salt['cmd.run']('expr ' ~ salt['cmd.shell']('cat /proc/cpuinfo | grep processor | wc -l') ~ ' \* 2') %}

{% set innodb_buffer_pool_size = salt['pillar.get']('mariadb:innodb_buffer_pool_size', default_innodb_buffer_pool_size) %}
{% set innodb_log_file_size = salt['pillar.get']('mariadb:innodb_log_file_size', '256M') %}
{% set innodb_thread_concurrency = salt['pillar.get']('mariadb:innodb_thread_concurrency', default_innodb_thread_concurrency) %}
{% set innodb_flush_log_at_trx_commit = salt['pillar.get']('mariadb:innodb_flush_log_at_trx_commit', 0) %}
{% set max_allowed_packet = salt['pillar.get']('mariadb:max_allowed_packet', '16M') %}
{% set open_files_limit = salt['pillar.get']('mariadb:open_files_limit', '10000') %}

mariadb-package:
  pkg.installed:
    - pkgs:
      - mariadb-server
      - mariadb-client

mariadb-service:
  service.running:
    - name: mysql
    - enable: True

mariadb-security:
  cmd.run:
    - name: echo -e "\ny\n{{ password }}\n{{ password }}\ny\ny\ny\ny" | /usr/bin/mysql_secure_installation
    - onlyif: echo "select password='' from user where user='root';" | mysql mysql | grep 1

mariadb-conf:
  ini.options_present:
    - name: '/etc/mysql/mariadb.conf.d/50-server.cnf'
    - separator: '='
    - sections:
        mysqld:
          innodb_buffer_pool_size: {{ innodb_buffer_pool_size }}
          innodb_log_file_size: {{ innodb_log_file_size }}
          innodb_thread_concurrency: {{ innodb_thread_concurrency }}
          innodb_flush_log_at_trx_commit: {{ innodb_flush_log_at_trx_commit }}
          max_allowed_packet: {{ max_allowed_packet }}
          open_files_limit: {{ open_files_limit }}
