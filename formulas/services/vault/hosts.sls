
{% set vault_host  = salt['pillar.get']('vault:hostname') %}
#{% set consul_host = salt['pillar.get']('consul:hostname') %}

hosts:
  host.present:
    - ip:
      - 127.0.0.1
      - 139.99.131.14
      - 172.17.0.2
      - 172.17.0.3
    - names:
      - consul.digitastuces.com
      - {{ vault_host }}