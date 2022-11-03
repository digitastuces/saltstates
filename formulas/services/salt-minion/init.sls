###########################################################################################################
#
# Service to install and configure salt-minion with its prerequisites
#
###########################################################################################################

include:
  - apt.transports.https
  - apt.repositories
  - salt.minion

restart-salt-minion:
  cmd.run:
    - name: 'salt-call service.restart salt-minion'
    - bg: True
    - onchanges:
      - file: /etc/salt/minion
      - file: /etc/salt/minion.d
      - pkg: salt-minion