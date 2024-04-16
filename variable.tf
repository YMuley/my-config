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
