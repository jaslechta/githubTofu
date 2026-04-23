variable "namespace_name" {
  description = "Vault child namespace path"
  type        = string
}

variable "enabled" {
  description = "Whether PKI engine should be created"
  type        = bool
  default     = false
}

variable "path" {
  description = "Mount path for the PKI engine"
  type        = string
  default     = "pki"
}

variable "role_name" {
  description = "PKI role name"
  type        = string
  default     = "default"
}

variable "default_lease_ttl_seconds" {
  description = "Default lease TTL for the PKI mount in seconds"
  type        = number
  default     = 3600
}

variable "max_lease_ttl_seconds" {
  description = "Maximum lease TTL for the PKI mount in seconds"
  type        = number
  default     = 86400
}

variable "ttl" {
  description = "Default certificate TTL passed to the role (e.g. 1h); empty string defers to mount default"
  type        = string
  default     = ""
}

variable "max_ttl" {
  description = "Maximum certificate TTL passed to the role (e.g. 24h); empty string defers to mount max"
  type        = string
  default     = ""
}

variable "allowed_domains" {
  description = "List of allowed domains for certificate issuance"
  type        = list(string)
  default     = []
}

variable "allow_subdomains" {
  description = "Allow subdomains of allowed_domains"
  type        = bool
  default     = false
}

variable "allow_bare_domains" {
  description = "Allow bare domains in allowed_domains"
  type        = bool
  default     = false
}

variable "allow_ip_sans" {
  description = "Allow IP SANs in certificates"
  type        = bool
  default     = false
}

variable "key_type" {
  description = "Key algorithm (rsa or ec)"
  type        = string
  default     = "rsa"
}

variable "key_bits" {
  description = "Key size in bits"
  type        = number
  default     = 2048
}

variable "issuing_certificates" {
  description = "URLs for issuing certificates"
  type        = list(string)
  default     = []
}

variable "crl_distribution_points" {
  description = "URLs for CRL distribution points"
  type        = list(string)
  default     = []
}

variable "ocsp_servers" {
  description = "URLs for OCSP servers"
  type        = list(string)
  default     = []
}

variable "dn" {
  description = "Distinguished name stored as PKI metadata"
  type        = string
  default     = ""
}

variable "serverdn" {
  description = "Server distinguished name stored as PKI metadata"
  type        = string
  default     = ""
}

variable "allowed_cn" {
  description = "List of allowed common names; merged into allowed_domains on the role"
  type        = list(string)
  default     = []
}

variable "app_support_group" {
  description = "Application support group name stored as PKI metadata"
  type        = string
  default     = ""
}

variable "app_support_email" {
  description = "Application support email stored as PKI metadata"
  type        = string
  default     = ""
}

variable "service_account_prefix" {
  description = "Service account prefix stored as PKI metadata"
  type        = string
  default     = ""
}

variable "kv_mount_path" {
  description = "KV v2 mount path used to store PKI metadata"
  type        = string
  default     = "kv"
}
