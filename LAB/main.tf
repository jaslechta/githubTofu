module "namespace" {
  for_each = local.namespace_config

  source = "../modules/namespace"

  namespace_name   = each.value.name
  create_namespace = true
  kv_mount_path    = try(each.value.kv.path, "kv")
  kv_version       = try(each.value.kv.version, 2)

  ldap_enabled     = try(each.value.ldap.enabled, true)
  ldap_path        = try(each.value.ldap.path, "ldap")
  ldap_description = try(each.value.ldap.description, "LDAP auth")

  policies         = try(each.value.policies, {})
  token_roles      = try(each.value.token_roles, {})
}
