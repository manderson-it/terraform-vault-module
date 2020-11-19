resource "vault_mount" "mount" {
  path        = var.lp
  type        = "kv-v2"
  description = "KV2 Secrets Engine for nonprod."
}

resource "vault_generic_secret" "secret" {
  path = "${var.lp}/helloworld"

  data_json = <<EOT
{
  "hello": "world"
}
EOT
}

resource "vault_policy" "policy" {
  name   = var.lp
  policy = <<-EOT
# List the KV folder
path "${var.lp}/metadata/"
{
  capabilities = ["list"]
}

# Manage secrets and versions
path "${var.lp}/data/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Read own policy
path "sys/policy/${var.lp}"
{
  capabilities = ["read", "list"]
}

path "sys/policies/acl/${var.lp}" {
  capabilities = ["read", "list"]
}
EOT
}

# /*
/*
resource "vault_kubernetes_auth_backend_role" "nonprod" {
  provider    = vault.platform-services
  backend                          = "k8s-klab"
  role_name                        = "f4igh-nonprod"
  bound_service_account_names      = ["f4igh-vault"]
  bound_service_account_namespaces = ["f4igh-nonprod-dev", "f4igh-nonprod-test", "f4igh-nonprod-tools"]
  token_ttl                        = "3600"
  token_policies                   = ["default", "f4igh-nonprod"]
}
*/
