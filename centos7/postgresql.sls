# Example pillar
#
#postgresql:
#  postgres_password: some_secure_password_change_me
#  encoding: UTF8
#  locale: en_US.UTF-8

{% set password = salt['pillar.get']('postgresql:postgres_password', '') %}
{% set encoding = salt['pillar.get']('postgresql:encoding', 'UTF8') %}
{% set locale = salt['pillar.get']('postgresql:locale', 'en_US.UTF8') %}

postgresql-package:
  pkg.installed:
    - pkgs:
      - postgresql-server
      - postgresql

postgresql-initdb:
  postgres_initdb.present:
    - name: /var/lib/pgsql/data
    - auth: md5
    - user: postgres
    - password: {{ password }}
    - encoding: {{ encoding }}
    - locale: {{ locale }}
    - runas: postgres

postgresql-service:
  service.running:
    - name: postgresql
    - enable: True

postgresql-firewalld:
  firewalld.present:
    - name: public
    - services:
      - postgres
    - prune_services: False
