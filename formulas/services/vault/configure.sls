
vault_config:
  file.managed:
    - name: /etc/vault.hcl
    - mode: '0640'
    - user: vault
    - group: vault
    - source: salt://services/vault/files/vault.hcl

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
