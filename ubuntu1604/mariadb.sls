# Example pillar
#
#mariadb:
#    root_password: some_secure_password_change_me

{% set password = salt['pillar.get']('mariadb:root_password', '') %}

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
