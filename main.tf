module "resource_Group" {
  source  = "app.terraform.io/Motifworks/resource_Group/azurerm"
  version = "1.0.2"
    resource_group_list = [
        {
            name        = "rg-ddi-poc" 
            location    = "eastus"
            tags        = {
                location      = "eastus"
                subscription  = "iac-dev"
                environment   = "poc"
            }
        },
        {
            name        = "rg-ddi-dev" 
            location    = "westus"
            tags        = {
                location      = "westus"
                subscription  = "iac-dev"
                environment   = "dev"
            }
        }
    ]
}


module "vnet" {
  source  = "app.terraform.io/Motifworks/vnet/azurerm"
  version = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  virtual_network_list = [
    {
        name        = "vnet-ddi-poc"
        location    = "eastus"
        resource_group_name = "rg-ddi-poc"
        address_space = ["10.100.0.0/16"] //["172.21.0.0/16"]
        dns_server = [] //["172.21.1.40", "172.21.1.41"]
        tags = {
            environment = "poc"
        }

    },
    {
        name        = "vnet-ddi-dev"
        location    = "westus"
        resource_group_name = "rg-ddi-dev"
        address_space = ["10.100.50.0/24"] //["172.21.0.0/16"]
        dns_server = [] //["172.21.1.40", "172.21.1.41"]
        tags = {
            environment = "poc"
        }

    }
    ]

}


