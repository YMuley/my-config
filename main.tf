module "resource_Group" {
  source  = "app.terraform.io/Motifworks/resource_Group/azurerm"
  version = "1.0.2"
  resource_group_list = [
    {
      name     = "rg-ddi-poc"
      location = "eastus"
      tags = {
        location     = "eastus"
        subscription = "iac-dev"
        environment  = "poc"
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
  source                = "app.terraform.io/Motifworks/vnet/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  virtual_network_list = [
    {
      name                = "vnet-ddi-poc"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc"
      address_space       = ["10.100.0.0/16"] //["172.21.0.0/16"]
      dns_server          = []                //["172.21.1.40", "172.21.1.41"]
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


module "subnet" {
  source  = "app.terraform.io/Motifworks/subnet/azurerm"
  version = "1.0.0"
  resource_group_output  = module.resource_Group.resource_group_output
  virtual_network_output = module.vnet.virtual_network_output
  service_endpoint_policy_output = module.service_endpoint_policy.service_endpoint_policy_output

  vnet_subnet_list = [
    {
        name = "sub-ddi-poc-web"
        resource_group_name     =   "rg-ddi-poc"
        virtual_network_name    =   "vnet-ddi-poc"
        address_prefixes        =   ["10.100.0.0/24"]
        service_endpoints       =   ["Microsoft.Storage"]
        service_endpoint_policy_ids     = "ddi-sep-poc" #["/subscriptions/8694217e-4a30-4107-9a12-aeac74b82f5c/resourceGroups/rg-ddi-poc/providers/Microsoft.Network/serviceEndpointPolicies/ddi-test-poc/"]
        private_endpoint_network_polices_enabled       =   "true"
        private_link_service_network_policies_enabled   =   "true"

        delegation = [
            {
            name    =  "delegation"
                service_delegation = [ 
                    {
                    name    =   "Microsoft.ContainerInstance/containerGroups"
                    actions =   ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
                
        } 
        ]

    } 
    ]
    },

     {
        name = "sub-ddi-dev-web"
        resource_group_name     =   "rg-ddi-dev"
        virtual_network_name    =   "vnet-ddi-dev"
        address_prefixes        =   ["10.100.0.0/24"]
        service_endpoints       =   []
        service_endpoint_policy_ids     =   null
        private_endpoint_network_polices_enabled       =   "false"
        private_link_service_network_policies_enabled   =   "false"

        delegation = [
            {
            name    =  "delegation"
                service_delegation = [ 
                    {
                    name    =   "Microsoft.ContainerInstance/containerGroups"
                    actions =   ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]

        } 
        ]

    } 
    ]
    }

  ]
}

module "service_endpoint_policy" {
  source  = "app.terraform.io/Motifworks/service_endpoint_policy/azurerm"
  version = "1.0.0"
   resource_group_output = module.resource_Group.resource_group_output
  service_endpoint_policy_list = [
    {
      name                  = "ddi-sep-poc"
      resource_group_name   = "rg-ddi-poc"
      location              = "eastus"

      definition = [
        {
          name              = "spe-stg-ddi-poc"
          description       = "poc policy"
          service           = "Microsoft.Storage"
          service_resources =  [ module.resource_Group.resource_group_output["rg-ddi-poc"].id ]

        }
        
        ]
    }
  ]
  

}
#
module "network_security_group" {
  source                = "app.terraform.io/Motifworks/network_security_group/azurerm"
  version               = "1.0.0"
#   resource_group_output = module.resource_Group.resource_group_output
#   network_security_group_list = [
#     {
#       name                = "nsg-ddi-poc"
#       location            = "eastus"
#       resource_group_name = "rg-ddi-poc"
#       tags = {
#         env = "poc"
#       }
#       security_rule = [
#         {
#           name                       = "HTTP"
#           priority                   = 1001
#           direction                  = "Inbound"
#           access                     = "Allow"
#           protocol                   = "Tcp"
#           source_port_range          = "*"
#           destination_port_range     = "80"
#           source_address_prefix      = "*"
#           destination_address_prefix = "*"
#         },
#         {
#           name                       = "HTTPS"
#           priority                   = 1002
#           direction                  = "Inbound"
#           access                     = "Allow"
#           protocol                   = "Tcp"
#           source_port_range          = "*"
#           destination_port_range     = "443"
#           source_address_prefix      = "*"
#           destination_address_prefix = "*"
#         }
#       ]

#     },
#     {
#       name                = "nsg-ddi-poc-one"
#       location            = "eastus"
#       resource_group_name = "rg-ddi-poc"
#       tags = {
#         env = "poc"
#       }
#       security_rule = [
#         {
#           name                       = "HTTP"
#           priority                   = 1001
#           direction                  = "Inbound"
#           access                     = "Allow"
#           protocol                   = "Tcp"
#           source_port_range          = "*"
#           destination_port_range     = "80"
#           source_address_prefix      = "*"
#           destination_address_prefix = "*"
#         }

#       ]


#   }]
 }


module "vnet_dns" {
  source  = "app.terraform.io/Motifworks/vnet-dns/azurerm"
  version = "1.0.2"

  azure_vnet_dns = [
    # {
    #   id          = "/subscriptions/8694217e-4a30-4107-9a12-aeac74b82f5c/resourceGroups/RG-KushalPatil/providers/Microsoft.Network/virtualNetworks/kush-vnet"
    #   dns_servers = ["10.168.10.1"]
    # }
  ]
}

