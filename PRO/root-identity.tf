resource "vault_ldap_auth_backend" "ldap" {
  path         = "ldap"
  url          = "ldaps://ldap.example.com"                           # REPLACE_ME
  userdn       = "OU=Users,DC=example,DC=com"                         # REPLACE_ME
  groupdn      = "OU=Groups,DC=example,DC=com"                        # REPLACE_ME
  binddn       = "CN=svc-vault,OU=ServiceAccounts,DC=example,DC=com" # REPLACE_ME
  bindpass     = var.ldap_bindpass
  userattr     = "sAMAccountName"
  groupattr    = "cn"
  groupfilter  = "(&(objectClass=group)(member={{.UserDN}}))"
  insecure_tls = false
  starttls     = false
  discoverdn   = false
  upndomain    = ""
}

data "vault_auth_backend" "ldap" {
  path = vault_ldap_auth_backend.ldap.path
}

resource "vault_identity_group" "external" {
  for_each = local.external_identity_groups

  name     = each.key
  type     = "external"
  policies = []

  metadata = {
    source      = "ldap"
    environment = "PRO"
    ad_group    = each.value.ad_group_name
    role        = each.value.role
    app         = each.value.app_name
  }
}

resource "vault_identity_group_alias" "external" {
  for_each = local.external_identity_groups

  name           = each.value.ad_group_name
  mount_accessor = data.vault_auth_backend.ldap.accessor
  canonical_id   = vault_identity_group.external[each.key].id
}