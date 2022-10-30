
{% set user = salt['pillar.get']('vault:user:name') %}

vault_config:
  file.managed:
    - name: /etc/vault.hcl
    - template: jinja
    - mode: '0640'
    - user: {{ user }}
    - group: {{ user }}
    - source: salt://services/vault/files/vault.hcl
    - context:
        consul_address: {{ salt['pillar.get']('vault:config:storage:consul:address') }}
        consul_path: {{ salt['pillar.get']('vault:config:storage:consul:path') }}
        consul_scheme: {{ salt['pillar.get']('vault:config:storage:consul:scheme') }}
        vault_address:  {{ salt['pillar.get']('vault:config:listener:tcp:address') }}
        tls_disable: {{ salt['pillar.get']('vault:config:listener:tcp:tls_disable') }}
        tls_cert_file: {{ salt['pillar.get']('vault:config:listener:tcp:tls_cert_file') }}
        tls_key_file: {{ salt['pillar.get']('vault:config:listener:tcp:tls_key_file') }}
        max_lease_ttl: {{ salt['pillar.get']('vault:config:max_lease_ttl') }}
        default_lease_ttl: {{ salt['pillar.get']('vault:config:default_lease_ttl') }}
        disable_mlock: {{ salt['pillar.get']('vault:config:disable_mlock') }}
        ui: {{ salt['pillar.get']('vault:config:ui') }}
        api_addr: {{ salt['pillar.get']('vault:config:api_addr') }}
        cluster_addr: {{ salt['pillar.get']('vault:config:cluster_addr') }}
        log_level: {{ salt['pillar.get']('vault:config:log_level') }}
        plugin_directory: {{ salt['pillar.get']('vault:config:plugin_directory') }}
        group: {{ user }}

vault_mlock_grant:
  pkg.installed:
    - name: libcap2-bin
  cmd.run:
    - name: 'setcap cap_ipc_lock=+ep /usr/local/bin/vault'
    - unless: 'systemctl status vault > /dev/null'
    - require:
        - pkg: vault_mlock_grant

vault_service:
  file.managed:
    - name: /etc/systemd/system/vault.service
    - mode: '0700'
    - source: salt://services/vault/files/vault.service
    - template: jinja
    - context:
        config_file: {{ salt['pillar.get']('vault:config:config_file') }}
        user: {{ user }}
        group: {{ user }}
    - require:
        - user: vault_user
        - file: vault_config
  service.running:
    - name: vault
  cmd.run:
    - name: 'systemctl reload vault'
    - onchanges:
      - file: vault_config
      - file: vault_service
      - file: vault_digitastuces_cert
