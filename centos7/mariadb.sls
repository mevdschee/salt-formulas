# Example pillar
#
#mariadb:
#    root_password: some_secure_password_change_me

{% set password = salt['pillar.get']('mariadb:root_password', '') %}

mariadb:
  pkg.installed:
    - pkgs:
      - mariadb-server
      - mariadb

mariadb_service:
  service.running:
    - name: mariadb
    - enable: True

mysql_secure_installation:
  cmd.run:
    - name: echo -e "\ny\n{{ password }}\n{{ password }}\ny\ny\ny\ny" | /usr/bin/mysql_secure_installation
    - unless: 'mysql mysql --batch -e "select * from user\G" 2>&1 | grep -q "ERROR 1045 (28000)"'
