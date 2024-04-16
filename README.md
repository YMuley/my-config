<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.75.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_availability_set"></a> [availability\_set](#module\_availability\_set) | app.terraform.io/Motifworks/availability_set/azurerm | 1.0.0 |
| <a name="module_azurerm_cdn_frontdoor_profile"></a> [azurerm\_cdn\_frontdoor\_profile](#module\_azurerm\_cdn\_frontdoor\_profile) | app.terraform.io/Motifworks/azurerm_cdn_frontdoor_profile/azurerm | 1.0.2 |
| <a name="module_cdn_frontdoor_custom_domain"></a> [cdn\_frontdoor\_custom\_domain](#module\_cdn\_frontdoor\_custom\_domain) | app.terraform.io/Motifworks/cdn_frontdoor_custom_domain/azurerm | 1.0.1 |
| <a name="module_cdn_frontdoor_endpoint"></a> [cdn\_frontdoor\_endpoint](#module\_cdn\_frontdoor\_endpoint) | app.terraform.io/Motifworks/cdn_frontdoor_endpoint/azurerm | 1.0.1 |
| <a name="module_cdn_frontdoor_origin"></a> [cdn\_frontdoor\_origin](#module\_cdn\_frontdoor\_origin) | app.terraform.io/Motifworks/cdn_frontdoor_origin/azurerm | 1.0.1 |
| <a name="module_cdn_frontdoor_origin_group"></a> [cdn\_frontdoor\_origin\_group](#module\_cdn\_frontdoor\_origin\_group) | app.terraform.io/Motifworks/cdn-frontdoor_origin_group/azurerm | 1.0.1 |
| <a name="module_cdn_frontdoor_rule_set"></a> [cdn\_frontdoor\_rule\_set](#module\_cdn\_frontdoor\_rule\_set) | app.terraform.io/Motifworks/cdn_frontdoor_rule_set/azurerm | 1.0.1 |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | app.terraform.io/Motifworks/firewall/azurerm | 1.0.0 |
| <a name="module_firewall_application_rule_collection"></a> [firewall\_application\_rule\_collection](#module\_firewall\_application\_rule\_collection) | app.terraform.io/Motifworks/firewall_application_rule_collection/azurerm | 1.0.0 |
| <a name="module_firewall_nat_rule_collection"></a> [firewall\_nat\_rule\_collection](#module\_firewall\_nat\_rule\_collection) | app.terraform.io/Motifworks/firewall_nat_rule_collection/azurerm | 1.0.0 |
| <a name="module_keyvault"></a> [keyvault](#module\_keyvault) | app.terraform.io/Motifworks/keyvault/azurerm | 1.0.6 |
| <a name="module_linux_vm"></a> [linux\_vm](#module\_linux\_vm) | app.terraform.io/Motifworks/linux-vm/azurerm | 1.0.0 |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | app.terraform.io/Motifworks/load_balancer/azurerm | 1.0.0 |
| <a name="module_loadbalancer_backend_address_pool_addresses"></a> [loadbalancer\_backend\_address\_pool\_addresses](#module\_loadbalancer\_backend\_address\_pool\_addresses) | app.terraform.io/Motifworks/loadbalancer_backend_address_pool_addresses/azurerm | 1.0.0 |
| <a name="module_loadbalancer_backend_pool"></a> [loadbalancer\_backend\_pool](#module\_loadbalancer\_backend\_pool) | app.terraform.io/Motifworks/loadbalancer_backend_pool/azurerm | 1.0.0 |
| <a name="module_loadbalancer_health_probe"></a> [loadbalancer\_health\_probe](#module\_loadbalancer\_health\_probe) | app.terraform.io/Motifworks/loadbalancer_health_probe/azurerm | 1.0.0 |
| <a name="module_loadbalancer_nat_pool"></a> [loadbalancer\_nat\_pool](#module\_loadbalancer\_nat\_pool) | app.terraform.io/Motifworks/loadbalancer_nat_pool/azurerm | 1.0.0 |
| <a name="module_loadbalancer_outbound_rule"></a> [loadbalancer\_outbound\_rule](#module\_loadbalancer\_outbound\_rule) | app.terraform.io/Motifworks/loadbalancer_outbound_rule/azurerm | 1.0.0 |
| <a name="module_loadbalancer_rule"></a> [loadbalancer\_rule](#module\_loadbalancer\_rule) | app.terraform.io/Motifworks/loadbalancer_rule/azurerm | 1.0.0 |
| <a name="module_loadbancer_backend_nic_association"></a> [loadbancer\_backend\_nic\_association](#module\_loadbancer\_backend\_nic\_association) | app.terraform.io/Motifworks/loadbancer_backend_nic_association/azurerm | 1.0.0 |
| <a name="module_managed_disk"></a> [managed\_disk](#module\_managed\_disk) | app.terraform.io/Motifworks/managed_disk/azurerm | 1.0.0 |
| <a name="module_management_lock"></a> [management\_lock](#module\_management\_lock) | app.terraform.io/Motifworks/management_lock/azurerm | 1.0.0 |
| <a name="module_network_interface_card"></a> [network\_interface\_card](#module\_network\_interface\_card) | app.terraform.io/Motifworks/network_interface_card/azurerm | 1.0.0 |
| <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group) | app.terraform.io/Motifworks/network_security_group/azurerm | 1.0.0 |
| <a name="module_nsg_nic_association"></a> [nsg\_nic\_association](#module\_nsg\_nic\_association) | app.terraform.io/Motifworks/nsg_nic_association/azurerm | 1.0.0 |
| <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint) | app.terraform.io/Motifworks/private_endpoint/azurerm | 1.0.0 |
| <a name="module_private_link_service"></a> [private\_link\_service](#module\_private\_link\_service) | app.terraform.io/Motifworks/private_link_service/azurerm | 1.0.0 |
| <a name="module_public_ip"></a> [public\_ip](#module\_public\_ip) | app.terraform.io/Motifworks/public_ip/azurerm | 1.0.0 |
| <a name="module_resource_Group"></a> [resource\_Group](#module\_resource\_Group) | app.terraform.io/Motifworks/resource_Group/azurerm | 1.0.5 |
| <a name="module_route_table"></a> [route\_table](#module\_route\_table) | app.terraform.io/Motifworks/route_table/azurerm | 1.0.0 |
| <a name="module_service_endpoint_policy"></a> [service\_endpoint\_policy](#module\_service\_endpoint\_policy) | app.terraform.io/Motifworks/service_endpoint_policy/azurerm | 1.0.0 |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | app.terraform.io/Motifworks/storage_account/azurerm | 1.0.0 |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | app.terraform.io/Motifworks/subnet/azurerm | 1.0.0 |
| <a name="module_subnet_nsg_association"></a> [subnet\_nsg\_association](#module\_subnet\_nsg\_association) | app.terraform.io/Motifworks/subnet_nsg_association/azurerm | 1.0.0 |
| <a name="module_subnet_route_table_association"></a> [subnet\_route\_table\_association](#module\_subnet\_route\_table\_association) | app.terraform.io/Motifworks/subnet_route_table_association/azurerm | 1.0.0 |
| <a name="module_traffic_manager_profile"></a> [traffic\_manager\_profile](#module\_traffic\_manager\_profile) | app.terraform.io/Motifworks/traffic_manager_profile/azurerm | 1.0.0 |
| <a name="module_useridentity"></a> [useridentity](#module\_useridentity) | app.terraform.io/Motifworks/useridentity/azurerm | 1.0.2 |
| <a name="module_vault_secret"></a> [vault\_secret](#module\_vault\_secret) | app.terraform.io/Motifworks/vault_secret/key | 1.0.0 |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | app.terraform.io/Motifworks/virtual_network/azurerm | 1.0.0 |
| <a name="module_virtual_network_dns"></a> [virtual\_network\_dns](#module\_virtual\_network\_dns) | app.terraform.io/Motifworks/virtual_network_dns/azurerm | 1.0.0 |
| <a name="module_window_vm"></a> [window\_vm](#module\_window\_vm) | app.terraform.io/Motifworks/window-vm/azurerm | 1.0.3 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_interface_card_output"></a> [network\_interface\_card\_output](#output\_network\_interface\_card\_output) | n/a |
| <a name="output_public_ip_output"></a> [public\_ip\_output](#output\_public\_ip\_output) | n/a |
| <a name="output_resource_group_output"></a> [resource\_group\_output](#output\_resource\_group\_output) | n/a |
| <a name="output_route_table_output"></a> [route\_table\_output](#output\_route\_table\_output) | n/a |
| <a name="output_service_endpoint_policy_output"></a> [service\_endpoint\_policy\_output](#output\_service\_endpoint\_policy\_output) | n/a |
| <a name="output_snet_network_security_group_output"></a> [snet\_network\_security\_group\_output](#output\_snet\_network\_security\_group\_output) | n/a |
| <a name="output_virtual_network_dns_output"></a> [virtual\_network\_dns\_output](#output\_virtual\_network\_dns\_output) | n/a |
| <a name="output_virtual_network_output"></a> [virtual\_network\_output](#output\_virtual\_network\_output) | n/a |
| <a name="output_vnet_subnet_output"></a> [vnet\_subnet\_output](#output\_vnet\_subnet\_output) | n/a |
<!-- END_TF_DOCS -->