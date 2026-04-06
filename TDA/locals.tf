locals {
  namespace_files = fileset("${path.module}/namespace", "*.yaml")

  raw_namespace_configs = {
    for file in local.namespace_files :
    trimsuffix(file, ".yaml") => yamldecode(file("${path.module}/namespace/${file}"))
  }

  namespace_list = flatten([
    for app_key, cfg in local.raw_namespace_configs : [
      for env_name, enabled in try(cfg.environments, {}) : {
        key              = "${cfg.application.name}-${env_name}"
        name             = "${cfg.application.name}-${env_name}"
        create           = enabled
        app_name         = cfg.application.name
        environment      = upper(env_name)
        kv               = try(cfg.kv, { path = "kv", version = 2 })
        ldap             = try(cfg.ldap, { enabled = true, path = "ldap", description = "LDAP auth" })
        policies         = try(cfg.policies, {})
        token_roles      = try(cfg.token_roles, {})
      }
    ]
  ])

  namespace_config = {
    for item in local.namespace_list :
    item.key => item
    if item.create
  }
}
