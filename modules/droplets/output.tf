output "servers_ipv4" {
  description = "Public IPv4 addresses of created droplets"
  value       = digitalocean_droplet.droplet_instance.*.ipv4_address
}

output "ssh_keys" {
  description = "Private key for SSH connection"
  value       = tls_private_key.ssh.private_key_pem
}