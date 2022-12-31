resource "local_file" "group_vars" {
  content         = <<EOT
---
ansible_ssh_private_key: cryptonodes.pem
    EOT
  filename        = "${path.module}/ansible/group_vars/${var.group_name}"
}

resource "local_file" "servers_ipv4" {
  content         = join("\n", [
    "[${var.group_name}]",
    join("\n", [
      for idx, s in module.cryptonodes_infrastructure.servers_ipv4:
      "${var.droplet_names[idx]} ansible_host=${s} ansible_user=root"
    ])
  ]
  )
  filename        = "${path.module}/ansible/inventory.txt"
}

resource "local_file" "ssh_keys" {
  content         = module.cryptonodes_infrastructure.ssh_keys
  filename        = "${path.module}/ansible/cryptonodes.pem"
  file_permission = "0400" 
}

resource "local_file" "ansible_playbooks_create_users" {
  count           = length(var.users)
  content         = <<EOT
---
- name: Create non-root user for ${var.users[count.index]}
  hosts: ${var.droplet_names[count.index]} 
  become: yes

  tasks:
  - name: Ping host
    ping:

  - name: Create non-root user ${var.users[count.index]} for ${var.droplet_names[count.index]}
    ansible.builtin.user:
      name: ${var.users[count.index]}
      group: sudo
      
  - name: Copy SSH keys in order to allow non-user connect via SSH
    shell: rsync --archive --chown=${var.users[count.index]}:${var.users[count.index]} ~/.ssh /home/${var.users[count.index]}
    EOT
  filename        = "${path.module}/ansible/playbooks/users/create_users_${var.droplet_names[count.index]}.yml"
  file_permission = "0700"
}


