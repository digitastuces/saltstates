// storage "file" {
//   path = "/var/vault/data"
//   }

# Storing Vault data in Consul

storage "consul" {
  address = "{{ consul_address }}"
  path = "{{ consul_path }}"
  scheme = "{{ consul_scheme }}"
}

service_registration "consul" {
  address  = "{{ consul_address }}"
}

listener "tcp" {
  address = "{{ vault_address }}"
  tls_disable = "{{ tls_disable }}"
  tls_cert_file = "{{ tls_cert_file }}"
  tls_key_file = "{{ tls_key_file }}"
}

api_addr = "{{ api_addr }}"
cluster_addr = "{{ cluster_addr }}"

max_lease_ttl = "{{ max_lease_ttl }}"
default_lease_ttl = "{{ default_lease_ttl }}"
disable_mlock = true

ui = true
log_level = "{{ log_level }}"
plugin_directory = "{{ plugin_directory }}"