output "resource_group_output" {
   value = module.resource_Group.resource_group_output
  }

output "virtual_network_output" {
  value = module.vnet.virtual_network_output
}

output "service_endpoint_policy_output" {
  value = module.service_endpoint_policy.service_endpoint_policy_output
}

output "vnet_subnet_output" {
  value = { module.subnet.vnet_subnet_output = {
      source                         = "app.terraform.io/Motifworks/subnet/azurerm"
      version                        = "1.0.0"
  }
  }
}