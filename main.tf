locals {
  lp_nonprod = "${var.lp}-nonprod"
  lp_prod    = "${var.lp}-prod"
}

resource "vault_mount" "nonprod" {
  path        = local.lp_nonprod
  type        = "kv-v2"
  description = "KV2 Secrets Engine"
}

resource "vault_generic_secret" "nonprod" {
  path = "${local.lp_nonprod}/helloworld"

  data_json = <<EOT
{
  "hello": "world"
}
EOT
  depends_on = [
    vault_mount.nonprod,
  ]
}

resource "vault_policy" "nonprod" {
  name   = local.lp_nonprod
  policy = <<-EOT
# List the KV folder
path "${local.lp_nonprod}/metadata/"
{
  capabilities = ["list"]
}

# Manage secrets and versions
path "${local.lp_nonprod}/data/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Read own policy
path "sys/policy/${local.lp_nonprod}"
{
  capabilities = ["read", "list"]
}

path "sys/policies/acl/${local.lp_nonprod}" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "nonprod" {
  for_each                         = var.cluster_name
  backend                          = "k8s-${each.value}"
  role_name                        = local.lp_nonprod
  bound_service_account_names      = ["${var.lp}-vault"]
  bound_service_account_namespaces = ["${var.lp}-dev", "${var.lp}-test", "${var.lp}-tools"]
  token_ttl                        = "3600"
  token_policies                   = ["default", "${local.lp_nonprod}"]
}

resource "vault_mount" "prod" {
  path        = local.lp_prod
  type        = "kv-v2"
  description = "KV2 Secrets Engine for prod."
}

resource "vault_generic_secret" "prod" {
  path = "${local.lp_prod}/helloworld"

  data_json = <<EOT
{
  "hello": "world"
}
EOT
  depends_on = [
    vault_mount.prod,
  ]
}

resource "vault_policy" "prod" {
  name   = local.lp_prod
  policy = <<-EOT
# List the KV folder
path "${local.lp_prod}/metadata/"
{
  capabilities = ["list"]
}

# Manage secrets and versions
path "${local.lp_prod}/data/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Read own policy
path "sys/policy/${local.lp_prod}"
{
  capabilities = ["read", "list"]
}

path "sys/policies/acl/${local.lp_prod}" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "prod" {
  for_each                         = var.cluster_name
  backend                          = "k8s-${each.value}"
  role_name                        = local.lp_prod
  bound_service_account_names      = ["${var.lp}-vault"]
  bound_service_account_namespaces = ["${local.lp_prod}"]
  token_ttl                        = "3600"
  token_policies                   = ["default", "${local.lp_prod}"]
}
