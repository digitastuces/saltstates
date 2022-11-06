
{% set vault_host  = salt['pillar.get']('vault:hostname') %}
#{% set consul_host = salt['pillar.get']('consul:hostname') %}

hosts:
  host.present:
    - ip:
      - 127.0.0.1
      - 193.70.87.42
    - names:
      - consul.digitastuces.com
      - {{ vault_host }}