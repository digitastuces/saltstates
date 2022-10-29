###########################################################################################################
#
# Service to install and configure vault with its prerequisites
#
###########################################################################################################

include:
  - .hosts
  - services.consul
  - .install
  - .certs
  - .configure
