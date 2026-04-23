output "namespace_name" {
  value = var.namespace_name
}

output "kv_path" {
  value = var.kv_mount_path
}

output "pki_mount_path" {
  value = try(module.pki[0].mount_path, null)
}
