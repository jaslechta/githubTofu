locals {
  namespace_files = fileset("${path.module}/namespace", "*.yaml")
  raw_namespace_configs = {
    for file in local.namespace_files :
    trimsuffix(file, ".yaml") => yamldecode(file("${path.module}/namespace/${file}"))
  }

  namespace_config = {
    for name, cfg in local.raw_namespace_configs :
    cfg.name => cfg
    if try(cfg.create, true)
  }
}
