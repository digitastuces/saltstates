// storage "file" {
//   path = "/var/vault/data"
//   }

# Storing Vault data in Consul

storage "consul" {
  address = "consul.digitastuces.com:8501"
  #address = "127.0.0.1:8501"
  path = "vault/"
  scheme = "https"
}

service_registration "consul" {
  address  = "consul.digitastuces.com:8501"
  #address = "127.0.0.1:8501"
  service = "vault"
}

listener "tcp" {
  #address = "vault.digitastuces.com:8200"
  address = "0.0.0.0:8200"
  tls_disable = 1
  tls_cert_file = "/var/vault/ssl/vault.digitastuces.com/fullchain.pem"
  tls_key_file = "/var/vault/ssl/vault.digitastuces.com/privkey.pem"
  cluster_address = "127.0.0.1:8201"
  proxy_protocol_behavior = "use_always"
}

#api_addr = "https://vault.digitastuces.com/vault/v1"
#cluster_addr = "https://vault.digitastuces.com:8201"
#api_addr = "https://127.0.0.1:8200/v1/"
api_addr = "https://vault.digitastuces.com/v1"
cluster_addr = "https://127.0.0.1:8201"

max_lease_ttl = "10h"
default_lease_ttl = "10h"
disable_mlock = true

disable_clustering = true


ui = true
log_level = "Debug"
