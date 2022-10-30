consul {
  address = "{{consul_address}}"
  ssl {
    enabled = true
  }
}

vault {
  address = "{{vault_address}}"
  vault_agent_token_file = "{{vault_agent_token_file}}"
}

template {
  source = "{{template_source}}"
  destination = "{{template_destination}}"
  error_on_missing_key = true
  wait {
    min = "{{template_wait_min}}"
    max = "{{template_wait_max}}"
  }
}