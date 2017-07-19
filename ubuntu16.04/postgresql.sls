# Example pillar
#
#postgresql:
#    postgres_password: some_secure_password_change_me

{% set password = salt['pillar.get']('postgresql:postgres_password', '') %}

postgresql:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-client

postgresql_service:
  service.running:
    - name: postgresql
    - enable: True

set_postgres_password:
  cmd.run:
    - name: echo "ALTER USER postgres WITH PASSWORD '{{ password }}';" | su postgres -c psql
    - unless: echo "\du" | PGPASSWORD={{ password }} psql -Upostgres -h127.0.0.1 | grep postgres
