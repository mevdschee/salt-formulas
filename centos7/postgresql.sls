# Example pillar
#
#postgresql:
#    postgres_password: some_secure_password_change_me

{% set password = salt['pillar.get']('postgresql:postgres_password', '') %}

postgresql:
  pkg.installed:
    - pkgs:
      - postgresql-server
      - postgresql

pgsql-data-dir:
  postgres_initdb.present:
    - name: /var/lib/pgsql/data
    - auth: md5
    - user: postgres
    - password: {{ password }}
    - encoding: UTF8
    - locale: C
    - runas: postgres

postgresql_service:
  service.running:
    - name: postgresql
    - enable: True
