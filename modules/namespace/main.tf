locals {
  namespace_enabled = var.create_namespace
}

resource "vault_namespace" "this" {
  count = local.namespace_enabled ? 1 : 0
  path  = var.namespace_name
}

resource "vault_mount" "kv" {
  count = local.namespace_enabled ? 1 : 0

  namespace   = var.namespace_name
  path        = var.kv_mount_path
  type        = "kv-v2"
  description = "KV for ${var.namespace_name}"

  options = {
    version = tostring(var.kv_version)
  }

  depends_on = [vault_namespace.this]
}

resource "vault_auth_backend" "ldap" {
  count = local.namespace_enabled && var.ldap_enabled ? 1 : 0

  namespace   = var.namespace_name
  type        = "ldap"
  path        = var.ldap_path
  description = var.ldap_description

  depends_on = [vault_namespace.this]
}

resource "vault_policy" "this" {
  for_each = local.namespace_enabled ? var.policies : {}

  namespace = var.namespace_name
  name      = each.key
  policy    = each.value

  depends_on = [vault_namespace.this]
}

resource "vault_token_auth_backend_role" "this" {
  for_each = local.namespace_enabled ? var.token_roles : {}

  namespace              = var.namespace_name
  role_name              = each.key
  allowed_policies       = each.value.allowed_policies
  orphan                 = try(each.value.orphan, true)
  renewable              = try(each.value.renewable, true)
  token_period           = try(each.value.token_period, null)
  token_ttl              = try(each.value.token_ttl, null)
  token_max_ttl          = try(each.value.token_max_ttl, null)
  token_explicit_max_ttl = try(each.value.token_explicit_max_ttl, null)

  depends_on = [vault_namespace.this, vault_policy.this]
}
