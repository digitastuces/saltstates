{% set consul_version = salt['pillar.get']('consul:version') %}
{% set download_host = salt['pillar.get']('consul:download_host') %}
{% set platform = salt['pillar.get']('consul:platform') %}
{% set source_hash = salt['pillar.get']('consul:hash') %}
{% set archive_format = salt['pillar.get']('consul:archive_format') %}
{% set user = salt['pillar.get']('consul:user:name') %}
{% set group = salt['pillar.get']('consul:group:name') %}
{% set consul_directory = salt['pillar.get']('consul:config:data_dir') %}
{% set consul_logs_directory = salt['pillar.get']('consul:config:consul_logs_directory') %}


consul:
  archive.extracted:
    - name: /tmp/consul
    - enforce_toplevel: False
    - source: https://{{download_host}}/consul/{{consul_version}}/consul_{{consul_version}}_{{platform}}.{{archive_format}}
    - source_hash: https://{{download_host}}/consul/{{consul_version}}/consul_{{consul_version}}_{{source_hash}}
    - unless: test -f /usr/local/bin/consul
  file.managed:
    - name: /usr/local/bin/consul
    - source: /tmp/consul/consul
    - mode: 0755
    - unless: test -f /usr/local/bin/consul
    - require:
      - archive: consul
  group.present:
    - name: {{group}}
  user.present:
    - name: {{user}}
    - fullname: Hashicorp Consul
    - shell: /usr/bin/nologin
    - groups:
        - {{group}}
        - users

consul_data_dir:
  file.directory:
    - name: {{consul_directory}}
    - user: {{user}}
    - group: {{group}}
    - mode: 0750

consul_logs_dir:
  file.directory:
    - name: {{consul_logs_directory}}
    - user: {{user}}
    - group: {{group}}
    - mode: 0750
