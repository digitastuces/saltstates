# Use digitastuces.com certificates

consul_digitastuces_cert:
  file.managed:
    - name: /var/consul/ssl/consul.digitastuces.com/cert.pem
    - source: salt://services/certs/files/cert1.pem
    - user: consul
    - group: users
    - mode: 0700
    - makedirs: True

consul_digitastuces_fullchain:
  file.managed:
    - name: /var/consul/ssl/consul.digitastuces.com/fullchain.pem
    - source: salt://services/certs/files/fullchain1.pem
    - user: consul
    - group: users
    - mode: 0700
    - makedirs: True

consul_digitastuces_privkey:
  file.managed:
    - name: /var/consul/ssl/consul.digitastuces.com/privkey.pem
    - source: salt://services/certs/files/privkey1.pem
    - user: consul
    - group: users
    - mode: 0700
    - makedirs: True

{% if not salt['file.contains']( '/root/.bashrc' , 'CONSUL_HTTP_ADDR') %} 
consul_bashrc:
  file.append:
    - name: /root/.bashrc
    - text: |
        export CONSUL_HTTP_ADDR=https://consul.digitastuces.com:8501
{% endif %}
