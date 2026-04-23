variable "namespace_name" {
  description = "Vault child namespace path"
  type        = string
}

variable "create_namespace" {
  description = "Whether namespace should be created"
  type        = bool
  default     = true
}

variable "kv_mount_path" {
  description = "Path for KV mount"
  type        = string
  default     = "kv"
}

variable "kv_version" {
  description = "KV secrets engine version"
  type        = number
  default     = 2
}

variable "policies" {
  description = "Policies to create in namespace"
  type        = map(string)
  default     = {}
}

variable "namespace_identity_groups" {
  description = "Internal identity groups in namespace linked to root external groups"
  type = map(object({
    member_group_ids = list(string)
    policies         = list(string)
    metadata         = optional(map(string), {})
  }))
  default = {}
}

variable "openshift_auth" {
  description = "Optional Kubernetes/OpenShift auth backend configuration"
  type = object({
    enabled                          = optional(bool, false)
    path                             = optional(string, "kubernetes")
    kubernetes_host                  = optional(string, "")
    kubernetes_ca_cert               = optional(string, "")
    token_reviewer_jwt               = optional(string, "")
    disable_local_ca_jwt             = optional(bool, true)
    issuer                           = optional(string, null)
    role_name                        = optional(string, "default")
    bound_service_account_names      = optional(list(string), [])
    bound_service_account_namespaces = optional(list(string), [])
    audience                         = optional(string, null)
    token_policies                   = optional(list(string), [])
    token_ttl                        = optional(number, 3600)
  })
  default = null
}

variable "pki" {
  description = "Optional PKI secrets engine configuration"
  type = object({
    enabled                   = optional(bool, false)
    path                      = optional(string, "pki")
    role_name                 = optional(string, "default")
    default_lease_ttl_seconds = optional(number, 3600)
    max_lease_ttl_seconds     = optional(number, 86400)
    ttl                       = optional(string, "")
    max_ttl                   = optional(string, "")
    allowed_domains           = optional(list(string), [])
    allow_subdomains          = optional(bool, false)
    allow_bare_domains        = optional(bool, false)
    allow_ip_sans             = optional(bool, false)
    key_type                  = optional(string, "rsa")
    key_bits                  = optional(number, 2048)
    issuing_certificates      = optional(list(string), [])
    crl_distribution_points   = optional(list(string), [])
    ocsp_servers              = optional(list(string), [])
    dn                        = optional(string, "")
    serverdn                  = optional(string, "")
    allowed_cn                = optional(list(string), [])
    app_support_group         = optional(string, "")
    app_support_email         = optional(string, "")
    service_account_prefix    = optional(string, "")
  })
  default = null
}
