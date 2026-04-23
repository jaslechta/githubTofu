output "mount_path" {
  value = try(vault_mount.pki[0].path, null)
}

output "role_name" {
  value = try(vault_pki_secret_backend_role.this[0].name, null)
}

output "enabled" {
  value = var.enabled
}
