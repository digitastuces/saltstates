consul {
  address = "consul.digitastuces.com:8501"
  ssl {
    enabled = true
  }
}

vault {
  address = "https://vault.digitastuces.com:8200"
  vault_agent_token_file = "/tmp/vault-token"
}

template {
  source = "/etc/app.yaml.tpl"
  destination = "/etc/app.yaml"
  error_on_missing_key = true
  wait {
    min = "2s"
    max = "10s"
  }
}