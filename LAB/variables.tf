variable "vault_address" {
  description = "Vault API address"
  type        = string
}

variable "vault_token" {
  description = "Vault token"
  type        = string
  sensitive   = true
}

variable "ldap_url" {
  description = "LDAP or LDAPS server URL"
  type        = string
}

variable "ldap_userdn" {
  description = "Base DN for users"
  type        = string
}

variable "ldap_groupdn" {
  description = "Base DN for groups"
  type        = string
}

variable "ldap_binddn" {
  description = "Bind DN used by Vault to search LDAP"
  type        = string
}

variable "ldap_bindpass" {
  description = "Bind password used by Vault to search LDAP"
  type        = string
  sensitive   = true
}

variable "ldap_userattr" {
  description = "LDAP username attribute"
  type        = string
  default     = "sAMAccountName"
}

variable "ldap_groupattr" {
  description = "LDAP group attribute"
  type        = string
  default     = "cn"
}

variable "ldap_groupfilter" {
  description = "LDAP group filter"
  type        = string
  default     = "(&(objectClass=group)(member={{.UserDN}}))"
}

variable "ldap_insecure_tls" {
  description = "Allow insecure TLS for LDAP"
  type        = bool
  default     = false
}

variable "ldap_starttls" {
  description = "Use STARTTLS for LDAP"
  type        = bool
  default     = false
}

variable "ldap_discoverdn" {
  description = "Enable discoverdn"
  type        = bool
  default     = false
}

variable "ldap_upndomain" {
  description = "UPN domain for Active Directory"
  type        = string
  default     = ""
}