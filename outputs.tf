output "public_ips" {
  description = "Public IP of each provisioned server, keyed by role."
  value       = { for k, s in aws_instance.server : k => s.public_ip }
}

output "ansible_inventory_hint" {
  description = "Paste these IPs into inventory.ini for the Ansible step."
  value = <<-EOT
    [nginx]
    ${aws_instance.server["nginx"].public_ip}

    [php_fpm]
    ${aws_instance.server["php_fpm"].public_ip}
  EOT
}
