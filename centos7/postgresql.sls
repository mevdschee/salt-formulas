# Example pillar
#
#postgresql:
#    postgres_password: some_secure_password_change_me

{% set password = salt['pillar.get']('postgresql:postgres_password', '') %}

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
    - encoding: UTF8
    - locale: C
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
