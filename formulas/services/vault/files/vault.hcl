// storage "file" {
//   path = "/var/vault/data"
//   }

# Storing Vault data in Consul

storage "consul" {
  address = "consul.digitastuces.com:8501"
  path = "vault/"
  scheme = "https"
}

listener "tcp" {
  address = "vault.digitastuces.com:8200"
  tls_disable = "false"
  tls_cert_file = "/var/vault/ssl/vault.digitastuces.com/fullchain.pem"
  tls_key_file = "/var/vault/ssl/vault.digitastuces.com/privkey.pem"
}

api_addr = "https://vault.digitastuces.com:8200"
cluster_addr = "https://vault.digitastuces.com:8201"

max_lease_ttl = "10h"
default_lease_ttl = "10h"
disable_mlock = true

ui = true
log_level = "Debug"