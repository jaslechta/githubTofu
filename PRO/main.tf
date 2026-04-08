module "namespace" {
  for_each = local.namespace_config

  source = "../modules/namespace"

  namespace_name            = each.value.name
  create_namespace          = true
  kv_mount_path             = try(each.value.kv.path, "kv")
  kv_version                = try(each.value.kv.version, 2)
  policies                  = try(each.value.policies, {})
  namespace_identity_groups = try(each.value.namespace_identity_groups, {})
}