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
      name     = "rg-ddi-dev"
      location = "westus"
      tags = {
        location     = "westus"
        subscription = "iac-dev"
        environment  = "dev"
      }
    }
  ]
}


module "virtual_network" {
  source                = "app.terraform.io/Motifworks/virtual_network/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  virtual_network_list = [
    {
      name                = "vnet-ddi-poc"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc"
      address_space       = ["10.100.0.0/16"] //["172.21.0.0/16"]  
      tags = {
        environment = "poc"
      }
    },
    {
      name                = "vnet-ddi-dev"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"
      address_space       = ["10.100.50.0/24"] //["172.21.0.0/16"]
      tags = {
        environment = "poc"
      }
    }
  ]

}


module "subnet" {
  source                         = "app.terraform.io/Motifworks/subnet/azurerm"
  version                        = "1.0.0"
  resource_group_output          = module.resource_Group.resource_group_output
  virtual_network_output         = module.virtual_network.virtual_network_output
  service_endpoint_policy_output = module.service_endpoint_policy.service_endpoint_policy_output

  vnet_subnet_list = [
    {
      name                                          = "sub-ddi-poc-web"
      resource_group_name                           = "rg-ddi-poc"
      virtual_network_name                          = "vnet-ddi-poc"
      address_prefixes                              = ["10.100.0.0/24"]
      service_endpoints                             = ["Microsoft.Storage"]
      service_endpoint_policy_ids                   = [] # compulsury input value needed otherwise module will throw error #["/subscriptions/8694217e-4a30-4107-9a12-aeac74b82f5c/resourceGroups/rg-ddi-poc/providers/Microsoft.Network/serviceEndpointPolicies/ddi-test-poc/"]
      private_endpoint_network_polices_enabled      = "true"
      private_link_service_network_policies_enabled = "false"

      delegation = [
        {
          name = "delegation"
          service_delegation = [{
            name    = "Microsoft.ContainerInstance/containerGroups"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]

          }]


        }
      ]
    },

    {
      name                                          = "sub-ddi-dev-web"
      resource_group_name                           = "rg-ddi-dev"
      virtual_network_name                          = "vnet-ddi-dev"
      address_prefixes                              = ["10.100.50.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.Web"]
      service_endpoint_policy_ids                   = ["ddi-sep-dev"]
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    }

  ]
  depends_on = [module.virtual_network, module.service_endpoint_policy]
}

module "service_endpoint_policy" {
  source                = "app.terraform.io/Motifworks/service_endpoint_policy/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  service_endpoint_policy_list = [
    {
      name                = "ddi-sep-poc"
      resource_group_name = "rg-ddi-poc"
      location            = "eastus"

      definition = [
        {
          name              = "spe-stg-ddi-poc"
          description       = "poc policy"
          service           = "Microsoft.Storage"
          service_resources = [module.resource_Group.resource_group_output["rg-ddi-poc"].id]

        }

      ]
    },
    {
      name                = "ddi-sep-dev"
      resource_group_name = "rg-ddi-dev"
      location            = "westus"

      definition = [
        {
          name              = "spe-stg-ddi-dev"
          description       = "poc policy"
          service           = "Microsoft.Storage"
          service_resources = [module.resource_Group.resource_group_output["rg-ddi-dev"].id]

        }

      ]
    }
  ]


}
#
module "network_security_group" {
  source                = "app.terraform.io/Motifworks/network_security_group/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  network_security_group_list = [
    {
      name                = "nsg-ddi-poc"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc"
      tags = {
        env = "poc"
      }
      security_rule = [
        {
          name                       = "HTTP"
          priority                   = 1001
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "HTTPS"
          priority                   = 1002
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]

    },
    {
      name                = "nsg-ddi-poc-one"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc"
      tags = {
        env = "poc"
      }
      security_rule = [
        {
          name                       = "HTTP"
          priority                   = 1001
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }

      ]


  }]
}


module "virtual_network_dns" {
  source                 = "app.terraform.io/Motifworks/virtual_network_dns/azurerm"
  version                = "1.0.0"
  virtual_network_output = module.virtual_network.virtual_network_output
  virtual_network_dns_list = [
    {
      virtual_network_name = "vnet-ddi-poc"
      dns_servers          = ["10.168.10.1"]
    },
    {
      virtual_network_name = "vnet-ddi-dev"
      dns_servers          = []
    }
  ]
  depends_on = [module.virtual_network]
}


module "public-ip" {
  source                = "app.terraform.io/Motifworks/public-ip/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  public_ip_list = [
    {
      name                = "publicip-ddi-poc"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc"
      allocation_method   = "Static"
      sku                 = "Basic"
      domain_name_label   = "unique-testing-label"
      tags = {
        environment = "poc"
      }
      sku_tier = "Regional"
    },
    {
      name                = "publicip-ddi-dev"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"
      allocation_method   = "Static"
      sku                 = "Basic"
      domain_name_label   = "another-unique-label"
      tags = {
        environment = "dev"
      }
      sku_tier = "Global"
    }
  ]
}

module "route_table" {
  source                = "app.terraform.io/Motifworks/route_table/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  route_table_list = [
    {
      name                = "rt-table1"
      location            = "eastus"
      resource_group_name = "rg-ddi-dev"
      tags = {
        environment = "poc"
        application = "example"
      }

      disable_bgp_route_propagation = true
      route_list = [
        {
          name                   = "route1"
          address_prefix         = "10.0.0.0/16"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.0.1"
        },
        {
          name                   = "route2"
          address_prefix         = "10.1.0.0/16"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.0.2"
        }
      ]
    }
  ]
}

module "network_interface_card" {
  source                = "app.terraform.io/Motifworks/network_interface_card/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  subnet_output         = module.subnet.vnet_subnet_output
  public_ip_output      = module.public-ip.public_ip_output

  network_interface_card_list = [
    {
      name                = "nic1"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc"
      tags = {
        environment = "poc"
      }
      ip_configuration = [
        {
          name                          = "config1"
          virtual_network_name          = "vnet-ddi-poc"
          subnet_name                   = "sub-ddi-poc-web"
          private_ip_address_allocation = "Dynamic"
          public_ip_name                = "public-ip1"
        }
      ]
    },
    {
      name                = "nic2"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"
      tags = {
        environment = "dev"
      }
      ip_configuration = [
        {
          name                          = "config2"
          virtual_network_name          = "vnet-ddi-dev"
          subnet_name                   = "sub-ddi-dev-web"
          private_ip_address_allocation = "Dynamic"
          public_ip_name                = "public-ip2"
        }
      ]
    }
  ]


}

module "subnet_nsg_association" {
  source                        = "app.terraform.io/Motifworks/subnet_nsg_association/azurerm"
  version                       = "1.0.0"
  subnet_output                 = module.subnet.vnet_subnet_output
  network_security_group_output = module.network_security_group.network_security_group_output
  # subnet_list                   = local.subnet_list
}

module "subnet_route_table_association" {
  source             = "app.terraform.io/Motifworks/subnet_route_table_association/azurerm"
  version            = "1.0.0"
  subnet_output      = module.subnet.vnet_subnet_output
  route_table_output = module.route_table.route_table_output
}
