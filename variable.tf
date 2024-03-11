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
