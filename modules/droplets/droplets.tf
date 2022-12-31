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

resource "digitalocean_volume" "droplet_volume" {
  region                  = var.region
  count                   = length(var.droplet_volumes)
  name                    = var.droplet_volumes[count.index]
  size                    = 200
  initial_filesystem_type = "ext4"
  description             = "Volume ${var.droplet_volumes[count.index]}"
}

resource "digitalocean_droplet" "droplet_instance" {
  image    = "ubuntu-20-04-x64"
  count    = length(var.droplet_names)
  name     = var.droplet_names[count.index]
  size     = var.droplet_size
  region   = var.region
  ssh_keys = [digitalocean_ssh_key.cryptonodes.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_project_resources" "cryptocurrencies_nodes_resources" {
  project   = digitalocean_project.cryptocurrencies_nodes.id
  resources = digitalocean_droplet.droplet_instance[*].urn
}

resource "digitalocean_volume_attachment" "droplets_with_volumes" {
  count      = length(var.droplet_names)
  droplet_id = digitalocean_droplet.droplet_instance[count.index].id
  volume_id  = digitalocean_volume.droplet_volume[count.index].id
}
