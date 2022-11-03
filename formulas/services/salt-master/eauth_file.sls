# Manage file external_authentication cf https://docs.saltstack.com/en/latest/ref/auth/all/salt.auth.file.html

eauth_file:
  file.managed:
    - name: /etc/salt/eauth_users.txt
    - source: salt://services/salt-master/files/eauth_users.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - context:
        users: {{ salt['pillar.get']('salt:eauth:users', {}) }}
