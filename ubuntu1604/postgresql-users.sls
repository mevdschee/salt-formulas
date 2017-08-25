# Example pillar
#
#postgresql:
#  encoding: UTF8
#  locale: en_US.UTF-8
#  users:
#    frank: frankspwd
#    hank: hankspwd

{% set postgres_password = salt['pillar.get']('postgresql:postgres_password', '') %}
{% set encoding = salt['pillar.get']('postgresql:encoding', 'UTF8') %}
{% set locale = salt['pillar.get']('postgresql:locale', 'en_US.UTF-8') %}

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
    - lc_collate: '{{ locale }}'
    - lc_ctype: '{{ locale }}'
    - db_user: postgres
    - db_password: '{{ postgres_password }}'

{% endfor %}
