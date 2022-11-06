{% set user = salt['pillar.get']('consul:user:name') %}
{% set group = salt['pillar.get']('consul:group:name') %}
{% set bind_addr = salt['pillar.get']('consul:config:bind_addr') %}

consul_config:
  file.managed:
    - name: /etc/consul.json
    - source: salt://services/consul/files/config/config.json
    - template: jinja
    - context:
        bind_addr: {{ salt['pillar.get']('consul:config:bind_addr') }}
        tls_cert_file: {{ salt['pillar.get']('consul:config:tls_cert_file') }}
        tls_key_file: {{ salt['pillar.get']('consul:config:tls_key_file') }}
        bootstrap_expect: {{ salt['pillar.get']('consul:config:bootstrap_expect') }}
        data_dir: {{ salt['pillar.get']('consul:config:data_dir') }}
        enable_debug: {{ salt['pillar.get']('consul:config:enable_debug') }}
        log_level: {{ salt['pillar.get']('consul:config:log_level') }}
    - user: {{user}}
    - group: {{group}}
    - mode: 0640

consul_service:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://services/consul/files/config/consul.service
    - template: jinja
    - context:
        user: {{user}}
        group: {{group}}
        bind_addr: {{bind_addr}}
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
