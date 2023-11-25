output "resource_group_output" {
  value = module.resource_Group.resource_group_output
}

output "virtual_network_output" {
  value = module.virtual_network.virtual_network_output
}

output "service_endpoint_policy_output" {
  value = module.service_endpoint_policy.service_endpoint_policy_output
}

output "vnet_subnet_output" {
  value = module.subnet.vnet_subnet_output
}

output "snet_network_security_group_output" {
  value = module.network_security_group.network_security_group_output
}

output "route_table_output" {
  value = module.route_table.route_table_output
}

output "virtual_network_dns_output" {
  value = module.virtual_network_dns.virtual_network_dns_output
}

output "public_ip_output" {
  value = module.public_ip.public_ip_output
}

output "network_interface_card_output" {
  value = module.network_interface_card.network_interface_card_output
}

output "storage_account_output" {
  value = module.storage_account.storage_account_output
}
