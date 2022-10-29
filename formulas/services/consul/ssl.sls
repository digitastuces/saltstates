consul_config:
  file.managed:
    - name: /etc/consul.json
    - source: salt://services/consul/files/config/config.json
    - user: consul
    - group: consul
    - mode: 0640

consul_service:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://services/consul/files/config/consul.service
  service.running:
    - name: consul
    - enable: True
    - require:
      - file: consul
      - file: consul_config
      - file: consul_service
    - watch:
      - file: consul
      - file: consul_service
      - file: consul_config
