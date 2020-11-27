![pre-commit](https://github.com/marc-leblanc/terraform-google-gke/workflows/pre-commit/badge.svg)

# terraform-vault-module

Terraform Module for Provisioning Vault Resources.

## Usage

Sample usage from Terraform Cloud:

~~~terraform
module "module" {
  source  = "app.terraform.io/manderson-it/module/vault"
  version = "1.0.0"

  providers = {
    vault = vault.platform-services
  }

  lp_nonprod = "f4igh-nonprod"
  lp_prod = "f4igh-nonprod"
}
~~~

## Requirements

### Installed Software

- [Terraform](https://www.terraform.io/downloads.html) ~> 0.12.29
- [Terraform Provider for Vault](https://registry.terraform.io/providers/hashicorp/vault/latest/docs) -> 2.16.0

### Configure Terraform Cloud

Set up your Terraform Cloud Organization/Workspace to consume this Terraform module.

## Inputs

| Name       | Description                         | Type     | Default | Required |
|------------|-------------------------------------|----------|---------|:--------:|
| lp_nonprod | licensePlate gets `-nonprod` suffix | `string` | none    | yes      |
| lp_prod    | licensePlate gets `-prod` suffix    | `string` | none    | yes      |

