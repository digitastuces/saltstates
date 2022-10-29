{% set consul_version = '1.13.3'  %}
#1.5.2

consul:
  archive.extracted:
    - name: /tmp/consul
    - enforce_toplevel: False
    - source: https://releases.hashicorp.com/consul/{{consul_version}}/consul_{{consul_version}}_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/{{consul_version}}/consul_{{consul_version}}_SHA256SUMS
    - unless: test -f /usr/local/bin/consul
  file.managed:
    - name: /usr/local/bin/consul
    - source: /tmp/consul/consul
    - mode: 0755
    - unless: test -f /usr/local/bin/consul
    - require:
      - archive: consul
  group.present:
    - name: consul
  user.present:
    - name: consul
    - fullname: Hashicorp Consul
    - shell: /usr/bin/nologin
    - groups:
        - consul
        - users

consul_data_dir:
  file.directory:
    - name: /var/consul
    - user: consul
    - group: consul
    - mode: 0750
