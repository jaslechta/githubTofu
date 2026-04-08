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

resource "vault_policy" "this" {
  for_each = local.namespace_enabled ? var.policies : {}

  namespace = var.namespace_name
  name      = each.key
  policy    = each.value

  depends_on = [vault_namespace.this]
}

resource "vault_identity_group" "internal" {
  for_each = local.namespace_enabled ? var.namespace_identity_groups : {}

  namespace        = var.namespace_name
  name             = each.key
  type             = "internal"
  policies         = each.value.policies
  member_group_ids = each.value.member_group_ids
  metadata         = try(each.value.metadata, {})

  depends_on = [
    vault_namespace.this,
    vault_policy.this
  ]
}