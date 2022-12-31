resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "digitalocean_ssh_key" "cryptonodes" {
  name       = "Cryptonode-SSH"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "digitalocean_project" "cryptocurrencies_nodes" {
  name        = "Cryptonodes"
  description = "DigitalOcean based cryptonodes infrastructure"
  purpose     = "Cutom cryptocurrency nodes"
}

resource "digitalocean_droplet" "droplet_instance" {
  image  = "ubuntu-20-04-x64"
  count  = length(var.droplet_names)
  name   = var.droplet_names[count.index]
  size   = var.droplet_size
  region = var.region
  ssh_keys = [digitalocean_ssh_key.cryptonodes.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_project_resources" "cryptocurrencies_nodes_resources" {
  project   = digitalocean_project.cryptocurrencies_nodes.id
  resources = digitalocean_droplet.droplet_instance[*].urn
}
