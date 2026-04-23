locals {
  namespace_files = fileset("${path.module}/namespace", "*.yaml")

  raw_namespace_configs = {
    for file in local.namespace_files :
    trimsuffix(file, ".yaml") => yamldecode(file("${path.module}/namespace/${file}"))
  }

  external_identity_groups = merge([
    for _, cfg in local.raw_namespace_configs : {
      "${cfg.application.name}-s2" = {
        ad_group_name = "MS_CZ_TDA_${upper(cfg.application.name)}_S2"
        role          = "s2"
        app_name      = cfg.application.name
      }
      "${cfg.application.name}-developer" = {
        ad_group_name = "MS_CZ_TDA_${upper(cfg.application.name)}_Developer"
        role          = "developer"
        app_name      = cfg.application.name
      }
      "${cfg.application.name}-tech" = {
        ad_group_name = "MS_CZ_TDA_TECH_${upper(cfg.application.name)}_Tech"
        role          = "tech"
        app_name      = cfg.application.name
      }
    }
  ]...)

  namespace_list = flatten([
    for _, cfg in local.raw_namespace_configs : [
      for env_name, env_cfg in try(cfg.environments, {}) : {
        key            = "${env_name}/${cfg.application.name}"
        name           = "${env_name}/${cfg.application.name}"
        create         = try(env_cfg.enabled, true)
        app_name       = cfg.application.name
        env_name       = env_name
        kv             = try(cfg.kv, { path = "kv", version = 2 })
        policies       = try(env_cfg.policies, {})
        openshift_auth = try(cfg.openshift_auth, null)
        pki            = try(cfg.pki, null)

        namespace_identity_groups = merge(
          contains(keys(try(env_cfg.policies, {})), "s2") ? {
            s2 = {
              member_group_ids = [vault_identity_group.external["${cfg.application.name}-s2"].id]
              policies         = ["s2"]
              metadata = {
                role = "s2"
                app  = cfg.application.name
                env  = env_name
              }
            }
          } : {},
          contains(keys(try(env_cfg.policies, {})), "developer") ? {
            developer = {
              member_group_ids = [vault_identity_group.external["${cfg.application.name}-developer"].id]
              policies         = ["developer"]
              metadata = {
                role = "developer"
                app  = cfg.application.name
                env  = env_name
              }
            }
          } : {},
          contains(keys(try(env_cfg.policies, {})), "tech") ? {
            tech = {
              member_group_ids = [vault_identity_group.external["${cfg.application.name}-tech"].id]
              policies         = ["tech"]
              metadata = {
                role = "tech"
                app  = cfg.application.name
                env  = env_name
              }
            }
          } : {}
        )
      }
    ]
  ])

  namespace_config = {
    for item in local.namespace_list :
    item.key => item
    if item.create
  }
}
