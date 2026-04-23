locals {
  has_metadata = anytrue([
    var.dn != "",
    var.serverdn != "",
    length(var.allowed_cn) > 0,
    var.app_support_group != "",
    var.app_support_email != "",
    var.service_account_prefix != "",
  ])
}

resource "vault_mount" "pki" {
  count = var.enabled ? 1 : 0

  namespace                 = var.namespace_name
  path                      = var.path
  type                      = "pki"
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds     = var.max_lease_ttl_seconds
}

resource "vault_pki_secret_backend_config_urls" "this" {
  count = var.enabled ? 1 : 0

  namespace               = var.namespace_name
  backend                 = vault_mount.pki[0].path
  issuing_certificates    = var.issuing_certificates
  crl_distribution_points = var.crl_distribution_points
  ocsp_servers            = var.ocsp_servers
}

resource "vault_pki_secret_backend_role" "this" {
  count = var.enabled ? 1 : 0

  namespace          = var.namespace_name
  backend            = vault_mount.pki[0].path
  name               = var.role_name
  ttl                = var.ttl != "" ? var.ttl : null
  max_ttl            = var.max_ttl != "" ? var.max_ttl : null
  allowed_domains    = concat(var.allowed_domains, var.allowed_cn)
  allow_subdomains   = var.allow_subdomains
  allow_bare_domains = var.allow_bare_domains
  allow_ip_sans      = var.allow_ip_sans
  key_type           = var.key_type
  key_bits           = var.key_bits
}

resource "vault_generic_endpoint" "pki_metadata" {
  count = var.enabled && local.has_metadata ? 1 : 0

  namespace    = var.namespace_name
  path         = "${var.kv_mount_path}/data/pki-metadata/${var.role_name}"
  disable_read = true

  data_json = jsonencode({
    data = {
      dn                     = var.dn
      serverdn               = var.serverdn
      allowed_cn             = var.allowed_cn
      app_support_group      = var.app_support_group
      app_support_email      = var.app_support_email
      service_account_prefix = var.service_account_prefix
    }
  })

  depends_on = [vault_mount.pki]
}
