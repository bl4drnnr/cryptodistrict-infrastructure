variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  default     = ""
}

variable "droplet_names" {
  description = "List of droplets names"
  type        = list(string)
  default     = [
    "certificate-authority-server",
    "openvpn-server",
    "nextcloud-server"
  ]
}

variable "group_name" {
  description = "Name of the droplets group"
  type        = string
  default     = "main_droplets"
}

variable "users" {
  description = "List of non-root users for each droplet"
  type        = list(string)
  default     = [
    "ca",
    "openvpn",
    "nc"
  ]
}

