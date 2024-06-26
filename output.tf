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

output "managed_disk_output" {
  value = module.managed_disk.managed_disk_output
}

# output "virtual_network_dns_output" {
#   value = module.virtual_network_dns.virtual_network_dns_output
# }

output "public_ip_output" {
  value = module.public_ip.public_ip_output
}

output "network_interface_card_output" {
  value = module.network_interface_card.network_interface_card_output
}

output "azure_firewall_output" {
  value = module.azure_firewall.azure_firewall_output
}

output "azure_firewall_policy_output" {
  value = module.azure_firewall_policy.azure_firewall_policy_output
}

# output "load_balancer_output" {
#   value = module.load_balancer.load_balancer_output
# }

# output "traffic_manager_profile_output" {
#   value = module.traffic_manager_profile.traffic_manager_profile_output
# }

output "windows_vm_output" {
  value     = module.window_vm.windows_vm_output
  sensitive = true
}

output "mssql_vm_output" {
  value     = module.mssql_vm.mssql_vm_output
  sensitive = true
}

# output "pass_sql_server_output" {
#   value = module.pass_sql_server.sql_server_output
# }

output "local_network_gateway_output" {
  value = module.local_network_gateway.local_network_gateway_output
}

output "virtual_network_gateway_output" {
  value = module.virtual_network_gateway.virtual_network_gateway_output
}