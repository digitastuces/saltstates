# Use digitastuces.com certificates

vault.digitastuces.com:
  host.present:
    - ip:
      - 127.0.0.1
      - 139.99.131.14
      - 172.17.0.3
    - names:
      - vault.digitastuces.com
      - consul.digitastuces.com

vault_digitastuces_cert:
  file.managed:
    - name: /etc/letsencrypt/live/vault.digitastuces.com/cert.pem
    - source: salt://services/certs/files/cert1.pem
    - user: vault
    - group: users
    - mode: 0700
    - makedirs: True

vault_digitastuces_fullchain:
  file.managed:
    - name: /etc/letsencrypt/live/vault.digitastuces.com/fullchain.pem
    - source: salt://services/certs/files/fullchain1.pem
    - user: vault
    - group: users
    - mode: 0700
    - makedirs: True

vault_digitastuces_privkey:
  file.managed:
    - name: /etc/letsencrypt/live/vault.digitastuces.com/privkey.pem
    - source: salt://services/certs/files/privkey1.pem
    - user: vault
    - group: users
    - mode: 0700
    - makedirs: True

{% if not salt['file.contains']( '/root/.bashrc' , 'VAULT_ADDR') %} 
/root/.bashrc:
  file.append:
    - text: |
        export VAULT_ADDR=https://vault.digitastuces.com:8200
{% endif %}
