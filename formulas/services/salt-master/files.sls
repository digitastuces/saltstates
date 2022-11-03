# Fix files permissions, see https://docs.saltproject.io/en/latest/ref/publisheracl.html#permission-issues

salt_master_log_dir:
  file.directory:
    - name: /var/log/salt
    - user: root
    - group: exploit
    - dir_mode: 770
    - require:
      - group: exploit

# done per file instead of using file.directory recurse to not modify key logfile
{% for file in ['master', 'minion', 'api'] %}
salt_master_log_{{ file }}:
  file.managed:
    - name: /var/log/salt/{{ file }}
    - user: root
    - group: exploit
    - mode: 660
{% endfor %}

{% for dir in ['saltstates', 'saltconfig'] %}
srv_{{ dir }}:
  file.directory: 
    - name: /srv/{{ dir }}
    - user: salt 
    - group: users 
    - dir_mode: 755 
{% endfor %} 
