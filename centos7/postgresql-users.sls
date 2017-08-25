# Example pillar
#
#postgresql:
#  encoding: UTF8
#  lc_collate: en_US.UTF-8
#  lc_ctype: en_US.UTF-8
#  users:
#    frank: frankspwd
#    hank: hankspwd

{% set postgres_password = salt['pillar.get']('postgresql:postgres_password', '') %}
{% set encoding = salt['pillar.get']('postgresql:encoding', 'UTF8') %}
{% set lc_collate = salt['pillar.get']('postgresql:lc_collate', None) %}
{% set lc_ctype = salt['pillar.get']('postgresql:lc_ctype', None) %}

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
    {% if lc_collate != None %}
    - lc_collate: '{{ lc_collate }}'
    {% endif %}
    {% if lc_ctype != None %}
    - lc_ctype: '{{ lc_ctype }}'
    {% endif %}
    - db_user: postgres
    - db_password: '{{ postgres_password }}'

{% endfor %}
