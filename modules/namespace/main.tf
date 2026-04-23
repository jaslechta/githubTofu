locals {
  namespace_enabled      = var.create_namespace
  openshift_auth_enabled = local.namespace_enabled && try(var.openshift_auth.enabled, false)
  pki_enabled            = local.namespace_enabled && try(var.pki.enabled, false)
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

resource "vault_auth_backend" "kubernetes" {
  count = local.openshift_auth_enabled ? 1 : 0

  namespace   = var.namespace_name
  type        = "kubernetes"
  path        = try(var.openshift_auth.path, "kubernetes")
  description = "Kubernetes auth for ${var.namespace_name}"

  depends_on = [vault_namespace.this]
}

resource "vault_kubernetes_auth_backend_config" "this" {
  count = local.openshift_auth_enabled ? 1 : 0

  namespace            = var.namespace_name
  backend              = vault_auth_backend.kubernetes[0].path
  kubernetes_host      = try(var.openshift_auth.kubernetes_host, "")
  kubernetes_ca_cert   = try(var.openshift_auth.kubernetes_ca_cert, "")
  token_reviewer_jwt   = try(var.openshift_auth.token_reviewer_jwt, "")
  disable_local_ca_jwt = try(var.openshift_auth.disable_local_ca_jwt, true)
  issuer               = try(length(var.openshift_auth.issuer) > 0, false) ? var.openshift_auth.issuer : null

  depends_on = [vault_auth_backend.kubernetes]
}

resource "vault_kubernetes_auth_backend_role" "this" {
  count = local.openshift_auth_enabled ? 1 : 0

  namespace                        = var.namespace_name
  backend                          = vault_auth_backend.kubernetes[0].path
  role_name                        = try(var.openshift_auth.role_name, "default")
  bound_service_account_names      = try(var.openshift_auth.bound_service_account_names, [])
  bound_service_account_namespaces = try(var.openshift_auth.bound_service_account_namespaces, [])
  audience                         = try(var.openshift_auth.audience, null)
  token_policies                   = try(var.openshift_auth.token_policies, [])
  token_ttl                        = try(var.openshift_auth.token_ttl, 3600)

  depends_on = [vault_auth_backend.kubernetes]
}

module "pki" {
  count  = local.pki_enabled ? 1 : 0
  source = "../pki"

  namespace_name            = var.namespace_name
  enabled                   = true
  path                      = try(var.pki.path, "pki")
  role_name                 = try(var.pki.role_name, "default")
  default_lease_ttl_seconds = try(var.pki.default_lease_ttl_seconds, 3600)
  max_lease_ttl_seconds     = try(var.pki.max_lease_ttl_seconds, 86400)
  ttl                       = try(var.pki.ttl, "")
  max_ttl                   = try(var.pki.max_ttl, "")
  allowed_domains           = try(var.pki.allowed_domains, [])
  allow_subdomains          = try(var.pki.allow_subdomains, false)
  allow_bare_domains        = try(var.pki.allow_bare_domains, false)
  allow_ip_sans             = try(var.pki.allow_ip_sans, false)
  key_type                  = try(var.pki.key_type, "rsa")
  key_bits                  = try(var.pki.key_bits, 2048)
  issuing_certificates      = try(var.pki.issuing_certificates, [])
  crl_distribution_points   = try(var.pki.crl_distribution_points, [])
  ocsp_servers              = try(var.pki.ocsp_servers, [])
  dn                        = try(var.pki.dn, "")
  serverdn                  = try(var.pki.serverdn, "")
  allowed_cn                = try(var.pki.allowed_cn, [])
  app_support_group         = try(var.pki.app_support_group, "")
  app_support_email         = try(var.pki.app_support_email, "")
  service_account_prefix    = try(var.pki.service_account_prefix, "")
  kv_mount_path             = var.kv_mount_path

  depends_on = [vault_namespace.this, vault_mount.kv]
}
