# Use digitastuces.com certificates

salt_digitastuces_cert:
  file.managed:
    - name:  /var/lib/salt/ssl/salt.digitastuces.com/cert.pem
    - source: salt://services/certs/files/cert1.pem
    - user: salt
    - group: users
    - mode: 0700
    - makedirs: True

salt_digitastuces_fullchain:
  file.managed:
    - name:  /var/lib/salt/ssl/salt.digitastuces.com/fullchain.pem
    - source: salt://services/certs/files/fullchain1.pem
    - user: salt
    - group: users
    - mode: 0700
    - makedirs: True

salt_digitastuces_privkey:
  file.managed:
    - name:  /var/lib/salt/ssl/salt.digitastuces.com/privkey.pem
    - source: salt://services/certs/files/privkey1.pem
    - user: salt
    - group: users
    - mode: 0700
    - makedirs: True