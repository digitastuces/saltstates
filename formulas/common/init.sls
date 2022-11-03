{%- set roles     = salt['pillar.get']('DAConfig:roles', []) %}
{%- set services  = salt['pillar.get']('DAConfig:services', []) %}
{%- set oscodename = salt['grains.get']('oscodename') %}

# user creation
user_adieng_present:
  user.present:
    - name: adieng
    - shell: /bin/bash
    - home: /home/adieng
    - gid: adieng
    - allow_gid_change: True
    - groups:
      - adm
      - exploit
      - sudo

user_deploy_present:
  user.present:
    - name: deploy
    - shell: /bin/bash
    - home: /home/deploy
    - gid: deploy
    - allow_gid_change: True
    - groups:
      - adm
      - exploit
      - sudo

user_salt_present:
  user.present:
    - name: salt
    - shell: /bin/bash
    - home: /srv/saltstates
    - gid: salt
    - allow_gid_change: True
    - groups:
      - root
      - exploit
      - sudo
include:
# check and clean
  - usersandgroups
  - packages.pkgs
  - sudoers
  #- sudoers.included
  - apt.repositories
  - logrotate.install

  # install services
  {% for service in services %}
  - services.{{ service }}
  {% endfor %}
