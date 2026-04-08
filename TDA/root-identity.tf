resource "vault_ldap_auth_backend" "ldap" {
  path         = "ldap"
  url          = var.ldap_url
  userdn       = var.ldap_userdn
  groupdn      = var.ldap_groupdn
  binddn       = var.ldap_binddn
  bindpass     = var.ldap_bindpass
  userattr     = var.ldap_userattr
  groupattr    = var.ldap_groupattr
  groupfilter  = var.ldap_groupfilter
  insecure_tls = var.ldap_insecure_tls
  starttls     = var.ldap_starttls
  discoverdn   = var.ldap_discoverdn
  upndomain    = var.ldap_upndomain
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
    environment = "TDA"
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