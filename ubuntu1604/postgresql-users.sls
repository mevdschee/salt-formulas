# Example pillar
#
#postgresql:
#  encoding: UTF8
#  lc_collate: C
#  lc_type: C
#  users:
#    frank: frankspwd
#    hank: hankspwd

{% set postgres_password = salt['pillar.get']('postgresql:postgres_password', '') %}
{% set encoding = salt['pillar.get']('postgresql:encoding', 'UTF8') %}
{% set lc_collate = salt['pillar.get']('postgresql:lc_collate', 'C') %}
{% set lc_type = salt['pillar.get']('postgresql:lc_type', 'C') %}

{% for username, password in salt['pillar.get']('postgresql:users', {}).items() %}

postgresql-user-{{ username }}:
  postgres_user.present:
    - name: '{{ username }}'
    - password: '{{ password }}'
    - db_user: postgres
    - db_password: '{{ postgres_password }}'

postgresql-database-{{ username }}:
  postgres_database.present:
    - name: '{{ username }}'
    - owner: '{{ username }}'
    - encoding: '{{ encoding }}'
    - lc_collate: '{{ lc_collate }}'
    - lc_type: '{{ lc_type }}'
    - db_user: postgres
    - db_password: '{{ postgres_password }}'

{% endfor %}
