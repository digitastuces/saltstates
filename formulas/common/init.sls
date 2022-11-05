{%- set roles     = salt['pillar.get']('DAConfig:roles', []) %}
{%- set services  = salt['pillar.get']('DAConfig:services', []) %}
{%- set oscodename = salt['grains.get']('oscodename') %}

include:
# check and clean
  - users
  - packages.pkgs
  - sudoers
  #- sudoers.included
  - apt.repositories
  - logrotate.install

  # install services
  {% for service in services %}
  - services.{{ service }}
  {% endfor %}
