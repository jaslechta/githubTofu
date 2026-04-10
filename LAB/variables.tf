variable "vault_token" {
  description = "Vault token"
  type        = string
  sensitive   = true
}

variable "ldap_bindpass" {
  description = "Bind password used by Vault to search LDAP"
  type        = string
  sensitive   = true
}