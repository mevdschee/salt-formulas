# Example pillar
#
#mariadb:
#  host: localhost
#  charset: utf8mb4
#  users:
#    frank: frankspwd
#    hank: hankspwd

{% set root_password = salt['pillar.get']('mariadb:root_password', '') %}
{% set host = salt['pillar.get']('mariadb:host', 'localhost') %}
{% set charset = salt['pillar.get']('mariadb:charset', 'utf8mb4') %}

mariadb-users-package:
  pkg.installed:
    - name: MySQL-python

{% for username, password in salt['pillar.get']('mariadb:users', {}).items() %}

mariadb-user-{{ username }}:
  mysql_user.present:
    - name: '{{ username }}'
    - host: '{{ host }}'
    - password: '{{ password }}'
    - connection_user: root
    - connection_pass: '{{ root_password }}'
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: en_US.utf8
    - require:
      - pkg: MySQL-python

mariadb-database-{{ username }}:
  mysql_database.present:
    - name: '{{ username }}'
    - character_set: '{{ charset }}'
    - collate: '{{ charset }}_general_ci'
    - connection_user: root
    - connection_pass: '{{ root_password }}'
    - connection_charset: utf8

mariadb-grants-{{ username }}:
  mysql_grants.present:
    - grant: all privileges
    - database: '{{ username }}.*'
    - user: '{{ username }}'
    - host: '{{ host }}'
    - connection_user: root
    - connection_pass: '{{ root_password }}'
    - connection_charset: utf8

{% endfor %}
