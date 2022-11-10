# Generate whitelist according to whitelist_name.
# It MUST match with a pre-declared digitastuces:services_whitelist and firewall:chains
{% macro generate_whitelist(whitelist_name) %}
    {{ whitelist_name }}:
    {% for name in stack.get('digitastuces').get('services_whitelist').get(whitelist_name)  %}
    {% set wl_name = stack.get('digitastuces').get('whitelists').get(name) %}
    {% if  wl_name is not none %}
      - comment: Default hosts in whitelist {{ name }}
        chain: {{whitelist_name }}
        source: {{ stack.get('digitastuces').get('whitelists').get(name, [] ) | join (',') }}
        jump: ACCEPT
        {% endif %}
  {% endfor %}
{% endmacro %}
