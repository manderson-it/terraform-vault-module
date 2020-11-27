resource "vault_mount" "nonprod" {
  path        = var.lp_nonprod
  type        = "kv-v2"
  description = "KV2 Secrets Engine"
}

resource "vault_generic_secret" "nonprod" {
  path = "${var.lp_nonprod}/helloworld"

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
  name   = var.lp_nonprod
  policy = <<-EOT
# List the KV folder
path "${var.lp_nonprod}/metadata/"
{
  capabilities = ["list"]
}

# Manage secrets and versions
path "${var.lp_nonprod}/data/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Read own policy
path "sys/policy/${var.lp_nonprod}"
{
  capabilities = ["read", "list"]
}

path "sys/policies/acl/${var.lp_nonprod}" {
  capabilities = ["read", "list"]
}
EOT
}

/*
resource "vault_kubernetes_auth_backend_role" "nonprod" {
  provider    = vault.platform-services
  backend                          = "k8s-${var.cluster_name}"
  role_name                        = "${var.lp_nonprod}"
  bound_service_account_names      = ["${var.lp}-vault"]
  bound_service_account_namespaces = ["${var.lp}-dev", "${var.lp}-test", "${var.lp}-tools"]
  token_ttl                        = "3600"
  token_policies                   = ["default", "${var.lp_nonprod}"]
}
resource "vault_kubernetes_auth_backend_role" "nonprod2" {
  provider    = vault.platform-services
  backend                          = "k8s-${var.cluster_name}"
  role_name                        = "${var.lp_nonprod}"
  bound_service_account_names      = ["${var.lp}-vault"]
  bound_service_account_namespaces = ["${var.lp}-dev", "${var.lp}-test", "${var.lp}-tools"]
  token_ttl                        = "3600"
  token_policies                   = ["default", "${var.lp_nonprod}"]
}
*/

resource "vault_mount" "prod" {
  path        = var.lp_prod
  type        = "kv-v2"
  description = "KV2 Secrets Engine for prod."
}

resource "vault_generic_secret" "prod" {
  path = "${var.lp_prod}/helloworld"

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
  name   = var.lp_prod
  policy = <<-EOT
# List the KV folder
path "${var.lp_prod}/metadata/"
{
  capabilities = ["list"]
}

# Manage secrets and versions
path "${var.lp_prod}/data/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Read own policy
path "sys/policy/${var.lp_prod}"
{
  capabilities = ["read", "list"]
}

path "sys/policies/acl/${var.lp_prod}" {
  capabilities = ["read", "list"]
}
EOT
}

/*
resource "vault_kubernetes_auth_backend_role" "prod" {
  provider    = vault.platform-services
  backend                          = "k8s-${var.cluster_name}"
  role_name                        = "${var.lp_prod}"
  bound_service_account_names      = ["${var.lp}-vault"]
  bound_service_account_namespaces = ["${var.lp_prod}"]
  token_ttl                        = "3600"
  token_policies                   = ["default", "${var.lp_prod}"]
}
resource "vault_kubernetes_auth_backend_role" "prod2" {
  provider    = vault.platform-services
  backend                          = "k8s-${var.cluster_name}"
  role_name                        = "${var.lp_prod}"
  bound_service_account_names      = ["${var.lp}-vault"]
  bound_service_account_namespaces = ["${var.lp_prod}"]
  token_ttl                        = "3600"
  token_policies                   = ["default", "${var.lp_prod}"]
}
*/
