###########################################################################################################
#
# Service to install and configure salt-minion with its prerequisites
#
###########################################################################################################

include:
  # - apt.transports.https
  # - apt.repositories
  - salt.minion
  # - .monitoring
