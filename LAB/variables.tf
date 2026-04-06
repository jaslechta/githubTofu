variable "vault_address" {
  description = "Vault API address"
  type        = string
}

variable "vault_token" {
  description = "Vault token"
  type        = string
  sensitive   = true
}
