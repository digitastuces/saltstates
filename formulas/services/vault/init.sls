###########################################################################################################
#
# Service to install and configure vault with its prerequisites
#
###########################################################################################################

include:
  - usersandgroups
  #- .hosts
  - services.consul
  - .install
  - .certs
  - .configure
  - services.nginx
  #- logrotate.jobs
