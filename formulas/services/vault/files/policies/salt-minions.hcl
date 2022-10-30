path "sys/mounts/*" {
  capabilities = ["read", "list", "create", "update", "delete"]
}

path "database/*" {
  capabilities = ["read", "list", "create", "update", "delete"]
}
