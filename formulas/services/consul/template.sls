{% set version = '0.20.0' %}
{% set user = salt['pillar.get']('consul:user:name') %}
{% set group = salt['pillar.get']('consul:group:name') %}
{% set consul_version = salt['pillar.get']('consul:version') %}
{% set download_host = salt['pillar.get']('consul:download_host') %}
{% set platform = salt['pillar.get']('consul:platform') %}
{% set source_hash = salt['pillar.get']('consul:hash') %}
{% set archive_format = salt['pillar.get']('consul:archive_format') %}
{% set user = salt['pillar.get']('consul:user:name') %}
{% set group = salt['pillar.get']('consul:group:name') %}
{% set consul_directory = salt['pillar.get']('consul:config:data_dir') %}

consul_template:
  archive.extracted:
    - name: /tmp/consul-template
    - enforce_toplevel: False
    - source: https://{{download_host}}/consul-template/{{version}}/consul-template_{{version}}_{{platform}}.{{archive_format}}
    - source_hash: https://{{download_host}}/consul-template/{{version}}/consul-template_{{version}}_{{source_hash}}
    - unless: test -f /usr/local/bin/consul-template
  file.managed:
    - name: /usr/local/bin/consul-template
    - source: /tmp/consul-template/consul-template
    - mode: 0755
    - unless: test -f /usr/local/bin/consul-template
    - require:
      - archive: consul_template

consul_template_config:
  file.managed:
    - name: /etc/consul-template.hcl
    - source: salt://services/consul/files/config/consul-template.hcl
    - template: jinja
    - context:
        consul_address: {{ salt['pillar.get']('consul:config:address') }}
        enable_ssl: {{ salt['pillar.get']('consul:config:ssl:enabled') }}
        vault_address:  {{ salt['pillar.get']('consul:vault:config:address') }}
        vault_agent_token_file: {{ salt['pillar.get']('consul:vault:config:vault_agent_token_file') }}
        template_source: {{ salt['pillar.get']('consul_template:tmpl:config:template:source') }}
        template_destination: {{ salt['pillar.get']('consul_template:tmpl:config:template:destination') }}
        template_error_on_missing_key: {{ salt['pillar.get']('consul_template:tmpl:template_error_on_missing_key') }}
        template_wait_min: {{ salt['pillar.get']('consul_template:tmpl:wait:min') }}
        template_wait_max: {{ salt['pillar.get']('consul_template:tmpl:wait:max') }}

consul_template_app_template:
  file.managed:
    - name: /etc/app.yaml.tpl
    - source: salt://services/consul/files/config/app.yaml.tpl

consul_vault_token_file:
  file.managed:
    - name: /tmp/vault-token
    - mode: 0755
    - user: {{user}}
    - group: {{group}}

consul_template_service:
  file.managed:
    - name: /etc/systemd/system/consul-template.service
    - source: salt://services/consul/files/config/consul-template.service
    - template: jinja
    - context:
        user: {{user}}
        group: {{group}}
  service.running:
    - name: consul-template
    - enable: True
    - require:
      - file: consul_template
      - file: consul_template_config
      - file: consul_template_app_template
      - file: consul_template_service
    - watch:
      - file: consul_template
      - file: consul_template_config
      - file: consul_template_app_template
      - file: consul_template_service

