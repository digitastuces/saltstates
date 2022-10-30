{% set vault_version = salt['pillar.get']('vault:version') %}
{% set platform = salt['pillar.get']('vault:platform') %}
{% set source_hash = salt['pillar.get']('vault:hash') %}
{% set archive_format = salt['pillar.get']('vault:archive_format') %}
{% set vault_directory = salt['pillar.get']('vault:config:vault_directory') %}
{% set logs = salt['pillar.get']('vault:config:vault_logs_directory') %}
{% set policies = salt['pillar.get']('vault:config:vault_policies_directory') %}
{% set user = salt['pillar.get']('vault:user:name') %}

vault:
  archive.extracted:
    - name: /usr/local/bin/
    - source: https://releases.hashicorp.com/vault/{{vault_version}}/vault_{{vault_version}}_{{platform}}.{{archive_format}}
    - source_hash: https://releases.hashicorp.com/vault/{{vault_version}}/vault_{{vault_version}}_{{source_hash}}
    - archive_format: {{archive_format}}
    - if_missing: /usr/local/bin/vault
    - source_hash_update: True
    - enforce_toplevel: False
  file.managed:
    - name: /usr/local/bin/vault
    - mode: '0755'
    - require:
      - archive: vault

vault_user:
  group.present:
    - name: {{ user }}
  user.present:
    - name: {{ user }}
    - fullname: Digitastuces Vault Server
    - shell: /usr/sbin/nologin
    - groups:
        - {{ user }}
        - users

vault_data_dir:
  file.directory:
    - name: {{ vault_directory }}
    - user: {{ user }}
    - group: {{ user }}
    - mode: '0700'

vault_logs_dir:
  file.directory:
    - name: {{ logs }}
    - user: {{ user }}
    - group: users
    - mode: '0777'

vault_policies_dir:
  file.directory:
    - name: {{ policies }}
    - user: {{ user }}
    - group: users
    - mode: '0755'