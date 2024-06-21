variable "azure_firewall_list" {
  type        = list(any)
  default     = []
  description = "list of azure firewall objects "
}

variable "azure_firewall_policy_list" {
  type        = list(any)
  default     = []
  description = "list of azure firewall policy objects "
}

variable "azure_firewall_application_rule_collection_list" {
  type        = list(any)
  default     = []
  description = "list of azure firewall application rule collection objects "
}

variable "azure_firewall_nat_rule_collection_list" {
  type        = list(any)
  default     = []
  description = "list of azure firewall nat rule collection objects "
}

variable "azure_firewall_network_rule_collection_list" {
  type        = list(any)
  default     = []
  description = "list of azure firewall network rule collection objects "
}

variable "azure_firewall_policy_rule_collection_group_list" {
  type        = list(any)
  default     = []
  description = "list of azure firewall rule collection objects "
}

variable "subnet_nsg_association_list" {
  type    = list(any)
  default = []
}

variable "subnet_route_table_association_list" {
  type    = list(any)
  default = []
}

variable "mssql_vm_list" {
  type        = list(any)
  default     = []
  description = "configuration list of mssql vm"
}

variable "managed_disk_list" {
  type    = list(any)
  default = []
}

variable "vm_data_disk_attach_list" {
  type    = list(any)
  default = []
}

variable "application_gateway_list" {
  type    = list(any)
  default = []
}

variable "storage_account_list" {
  type    = list(any)
  default = []
}

variable "terraform_subnet_route_table_association_list" {
  type = list(any)
  description = "list of route table subnets for association"
}

# variable "pass_sql_server_list" {
#   type = list(any)
#   description = "list of sql servers "
# }

variable "local_network_gateway_list" {
  type = list(any)
  description = "list of local network gateways config"
}

variable "vpn_list" {
  type = list(any)
  description = "list of vpn gateway config"
}

variable "vpn_connection_list" {
  type = list(any)
  default = []
  description = "vpn configuration list"
}