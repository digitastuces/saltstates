{% set user = salt['pillar.get']('vault:user:name') %}
{% set home = salt['pillar.get']('vault:user:home') %}

include:
  - .files


# XDG_RUNTIME_DIR is a prerequisite for running systemctl --user command
{% if not salt['file.contains']( home ~ '/.bashrc' , 'XDG_RUNTIME_DIR') %} 
{{ home }}/.bashrc:
  file.append:
    - text: |
        export XDG_RUNTIME_DIR=/run/user/$(id -u {{ user }})
{% endif %}

# VAULT_ADDR
{% if not salt['file.contains']( home ~ '/.bashrc' , 'VAULT_ADDR') %} 
{{ home }}/.bashrc:
  file.append:
    - text: |
        export VAULT_ADDR=https://vault.digitastuces.com:8200
{% endif %}
