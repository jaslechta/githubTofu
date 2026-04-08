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