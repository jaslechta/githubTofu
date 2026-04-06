variable "namespace_name" {
  description = "Vault namespace name"
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

variable "ldap_enabled" {
  description = "Enable LDAP auth mount"
  type        = bool
  default     = true
}

variable "ldap_path" {
  description = "LDAP auth mount path"
  type        = string
  default     = "ldap"
}

variable "ldap_description" {
  description = "LDAP auth description"
  type        = string
  default     = "LDAP auth"
}

variable "policies" {
  description = "Map of policies to create"
  type        = map(string)
  default     = {}
}

variable "token_roles" {
  description = "Token roles"
  type = map(object({
    allowed_policies        = list(string)
    orphan                  = optional(bool, true)
    renewable               = optional(bool, true)
    token_period            = optional(number)
    token_ttl               = optional(number)
    token_max_ttl           = optional(number)
    token_explicit_max_ttl  = optional(number)
  }))
  default = {}
}
