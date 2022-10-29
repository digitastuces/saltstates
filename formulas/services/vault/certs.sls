# Use digitastuces.com certificates

vault_digitastuces_cert:
  file.managed:
    - name:  /var/vault/ssl/vault.digitastuces.com/cert.pem
    - source: salt://services/certs/files/cert1.pem
    - user: vault
    - group: users
    - mode: 0700
    - makedirs: True

vault_digitastuces_fullchain:
  file.managed:
    - name:  /var/vault/ssl/vault.digitastuces.com/fullchain.pem
    - source: salt://services/certs/files/fullchain1.pem
    - user: vault
    - group: users
    - mode: 0700
    - makedirs: True

vault_digitastuces_privkey:
  file.managed:
    - name:  /var/vault/ssl/vault.digitastuces.com/privkey.pem
    - source: salt://services/certs/files/privkey1.pem
    - user: vault
    - group: users
    - mode: 0700
    - makedirs: True

{% if not salt['file.contains']( '/root/.bashrc' , 'VAULT_ADDR') %} 
vault_bashrc:
  file.append:
    - name: /root/.bashrc
    - text: |
        export VAULT_ADDR=https://vault.digitastuces.com:8200
{% endif %}
