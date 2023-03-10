output "servers_ipv4" {
  description = "Public IPv4 addresses of created droplets"
  value       = module.cryptonodes_infrastructure.servers_ipv4
}

output "ssh_keys" {
  description = "Private key for SSH connection"
  value       = module.cryptonodes_infrastructure.ssh_keys
  sensitive   = true
}

