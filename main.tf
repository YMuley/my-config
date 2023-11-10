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
      address_space       = ["10.100.0.0/20"] //["172.21.0.0/16"]  
      tags = {
        environment = "poc"
      }
    },
    {
      name                = "vnet-ddi-dev"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"
      address_space       = ["10.100.16.0/20"] //["172.21.0.0/16"]
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
      address_prefixes                              = ["10.100.16.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.Web"]
      service_endpoint_policy_ids                   = ["ddi-sep-dev"]
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },
     {
      name                                          = "sub-ddi-poc-lb"
      resource_group_name                           = "rg-ddi-poc"
      virtual_network_name                          = "vnet-ddi-poc"
      address_prefixes                              = ["10.100.2.0/24"]
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },
    {
      name                                          = "GatewaySubnet"
      resource_group_name                           = "rg-ddi-poc"
      virtual_network_name                          = "vnet-ddi-poc"
      address_prefixes                              = ["10.100.1.0/24"]
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },

    {
      name                                          = "GatewaySubnet"
      resource_group_name                           = "rg-ddi-dev"
      virtual_network_name                          = "vnet-ddi-dev"
      address_prefixes                              = ["10.100.17.0/24"]
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
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
    # {
    #   name                = "ddi-sep-poc"
    #   resource_group_name = "rg-ddi-poc"
    #   location            = "eastus"

    #   definition = [
    #     {
    #       name              = "spe-stg-ddi-poc"
    #       description       = "poc policy"
    #       service           = "Microsoft.Storage"
    #       service_resources = [module.resource_Group.resource_group_output["rg-ddi-poc"].id]

    #     }

    #   ]
    # },
    {
      name                = "ddi-sep-dev"
      resource_group_name = "rg-ddi-dev"
      location            = "westus"

      definition = [
        {
          name              = "spe-stg-ddi-dev"
          description       = "poc policy"
          service           = "Microsoft.Storage"
          service_resources = [module.resource_Group.resource_group_output["rg-ddi-dev"].id,
                                module.storage_account.storage_account_output["ddistorageacc1"].id]

        }

      ]
    }
  ]


}

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
    # {
    #   name                = "nsg-ddi-poc-one"
    #   location            = "eastus"
    #   resource_group_name = "rg-ddi-poc"
    #   tags = {
    #     env = "poc"
    #   }
    # security_rule = [
    #   {
    #     name                       = "HTTP"
    #     priority                   = 1001
    #     direction                  = "Inbound"
    #     access                     = "Allow"
    #     protocol                   = "Tcp"
    #     source_port_range          = "*"
    #     destination_port_range     = "80"
    #     source_address_prefix      = "*"
    #     destination_address_prefix = "*"
    #   }

    # ]
    # },
    {
      name                = "nsg-ddi-dev-one"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"

      tags = {
        env = "dev"
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
    }
  ]
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
module "vault_secret" {
  source  = "app.terraform.io/Motifworks/vault_secret/key"
  version = "1.0.0"
  key_vault_output = module.keyvault.key_vault_output
  key_vault_secret_list = [
 { 
   name         = "secret-sauce"
   value        = "szechuan"
   key_vault_name = "testingkvref1"
 
 }
  ]
depends_on = [module.keyvault]
}

module "public_ip" {
  source                = "app.terraform.io/Motifworks/public_ip/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  public_ip_list = [
    {
      name                = "publicip-ddi-poc"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc"
      allocation_method   = "Dynamic"
      sku                 = "Basic"
      domain_name_label   = "unique-testing-label"
      tags = {
        environment = "poc"
      }
      sku_tier = "Regional"
    },
    {
      name                = "public-ip-ddi-dev"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"
      allocation_method   = "Static"
      sku                 = "Basic"
      domain_name_label   = "another-unique-label"
      tags = {
        environment = "dev"
      }
      sku_tier = "Regional"
    },
    {
      name                = "public-ip-ddi-lb"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"
      allocation_method   = "Static"
      sku                 = "Standard"
      domain_name_label   = "lb-unique-label"
      tags = {
        environment = "dev"
      }
      sku_tier = "Regional"
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
  public_ip_output      = module.public_ip.public_ip_output

  network_interface_card_list = [
    {
      name                = "nic1"
      location            = "westus"
      resource_group_name = "rg-ddi-dev"
      tags = {
        environment = "dev"
      }
      ip_configuration = [
        {
          name                          = "config1"
          virtual_network_name          = "vnet-ddi-dev"
          subnet_name                   = "sub-ddi-dev-web"
          private_ip_address_allocation = "Dynamic"
          public_ip_name                = "public-ip-ddi-dev"
          private_ip_address            = null
        }
      ]
    },

    # {
    #   name                = "nic2"
    #   location            = "westus"
    #   resource_group_name = "rg-ddi-dev"
    #   tags = {
    #     environment = "dev"
    #   }
    #   ip_configuration = [
    #     {
    #       name                          = "config2"
    #       virtual_network_name          = "vnet-ddi-dev"
    #       subnet_name                   = "sub-ddi-dev-web"
    #       private_ip_address_allocation = "Dynamic"
    #       public_ip_name                = "public-ip2"
    # public_ip_name                = "ddi-fw-hub-wus"
    #   private_ip_address            = null
    #     }
    #   ]
    # }
  ]


}

module "subnet_nsg_association" {
  source                        = "app.terraform.io/Motifworks/subnet_nsg_association/azurerm"
  version                       = "1.0.0"
  subnet_output                 = module.subnet.vnet_subnet_output
  network_security_group_output = module.network_security_group.network_security_group_output

  association_list = [
    {
      nsg_name  = "nsg-ddi-poc"
      subnet_id = format("%s/%s", "vnet-ddi-poc", "sub-ddi-poc-web") #
    }
  ]
}

module "subnet_route_table_association" {
  source             = "app.terraform.io/Motifworks/subnet_route_table_association/azurerm"
  version            = "1.0.0"
  subnet_output      = module.subnet.vnet_subnet_output
  route_table_output = module.route_table.route_table_output

  association_list = [
    {
      route_table_name = "rt-table1"
      subnet_id        = format("%s/%s", "vnet-ddi-poc", "sub-ddi-poc-web")
    }
  ]
}

module "nsg_nic_association" {
  source                        = "app.terraform.io/Motifworks/nsg_nic_association/azurerm"
  version                       = "1.0.0"
  network_interface_card_output = module.network_interface_card.network_interface_card_output
  network_security_group_output = module.network_security_group.network_security_group_output

  association_list = [
    {
      network_security_group_name = "nsg-ddi-dev-one"
      network_interface_card_name = format("%s/%s", "rg-ddi-dev", "nic1")
    }
  ]
}

 module "keyvault" {
   source  = "app.terraform.io/Motifworks/keyvault/azurerm"
   version = "1.0.6"

   key_vault_list = [
     {
       name                = "testingkvref1"
       resource_group_name = "rg-ddi-dev"
       location            = "eastus"

       sku_name                        = "standard"
       tenant_id                       = "fd41ee0d-0d97-4102-9a50-c7c3c5470454"
       enabled_for_deployment          = true
       enabled_for_disk_encryption     = false
       enabled_for_template_deployment = false
       enable_rbac_authorization       = false
       soft_delete_retention_days      = 7
       purge_protection_enabled        = false
       public_network_access_enabled   = true
       network_acls = [
         {
           bypass         = "AzureServices"
           default_action = "Allow"
         }
       ]
       access_policy = [
         {
           tenant_id : "fd41ee0d-0d97-4102-9a50-c7c3c5470454"
           object_id : "0ac91507-a04a-4fac-bfca-a143cea93b33"
           resource_type           = "user"
           application_id          = null
           certificate_permissions = ["Get", "Create", "Delete", "Update"]
           key_permissions         = ["Get", "Create", "Delete", "Update"]
           secret_permissions      = ["Get","List","Set","Delete","Recover","Backup","Restore","Purge"]
           storage_permissions     = ["Get", "Set", "Delete", "Update"]
         }
       ]

#       contact = [
#         {
#           email = "Vijay.Yadav@motifworks.com"
#           name  = "Vijay Yadav"
#           phone = "93042322"
#         }
#       ]

       tags = {
         env = "poc"
       }
     }
   ]
 }

module "storage_account" {
  source                = "app.terraform.io/Motifworks/storage_account/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  subnet_output         = module.subnet.vnet_subnet_output


  storage_account_list = [
    {
      name                      = "ddistorageacc1"
      resource_group_name       = "rg-ddi-dev"
      location                  = "westus"
      account_tier              = "Standard"
      account_replication_type  = "LRS"
      enable_https_traffic_only = true
      tags = {
        environment = "dev"
      }
      allow_https_only              = true
      minimum_tls_version           = "TLS1_2"
      shared_access_key_enabled     = true
      public_network_access_enabled = true
      network_rules = [
        {
          default_action       = "Allow"
          bypass               = ["AzureServices"]
          ip_rules             = ["23.45.1.0/30"]
          virtual_network_name = "vnet-ddi-dev"
          subnet_name          = "sub-ddi-dev-web"
        }
      ]
    },

    {
      name                      = "ddistorageacc"
      resource_group_name       = "rg-ddi-dev"
      location                  = "westus"
      account_tier              = "Standard"
      account_replication_type  = "LRS"
      enable_https_traffic_only = true
      tags = {
        environment = "dev"
      }
      allow_https_only              = true
      minimum_tls_version           = "TLS1_2"
      shared_access_key_enabled     = false
      public_network_access_enabled = true
      network_rules = [
        {
          default_action       = "Allow"
          bypass               = ["AzureServices"]
          ip_rules             = ["23.45.1.0/30"]
          virtual_network_name = "vnet-ddi-dev"
          subnet_name          = "sub-ddi-dev-web"
        }
      ]
    }
  ]
}
module "useridentity" {
  source  = "app.terraform.io/Motifworks/useridentity/azurerm"
  version = "1.0.2"

  user_assigned_identity_list = [
    {
      name : "user-managed"
      resource_group_name = "rg-ddi-dev"
      location            = "eastus"
      tags = {
        environment = "nertwork-team"
      }
    }
  ]
}

module "managed_disk" {
  source                = "app.terraform.io/Motifworks/managed_disk/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  managed_disk_list = [
    {
      name                 = "ddidisk1"
      resource_group_name  = "rg-ddi-dev"
      location             = "westus"
      storage_account_type = "Standard_LRS"
      create_option        = "Empty"
      disk_size_gb         = 10
      tags = {
        environment = "dev"
      }
    }
  ]
}

module "load_balancer" {
  source  = "app.terraform.io/Motifworks/load_balancer/azurerm"
  version = "1.0.0"

  resource_group_output = module.resource_Group.resource_group_output
  public_ip_output      = module.public_ip.public_ip_output
  subnet_output         = module.subnet.vnet_subnet_output

  loadbalancer_list = [
    {
      name                = "lb-ddi-dev"
      resource_group_name = "rg-ddi-dev"
      location            = "westus"
      sku                 = "Standard" #[possible values : Standard,Gateway,Basic]
      sku_tier            = "Regional" #[possible values : Regional,Global]
      tags = { env = "dev"
        org = "ddi"
      }
      frontend_ip_configuration = [
        {
          name                          = "lb-pip-ddi-dev"
          zones                         = []
          public_ip_name                = "public-ip-ddi-lb"
          subnet_name                   = null
          private_ip_address_allocation = null
        }
      ]
    },

    {
      name                = "lb-ddi-devone"
      resource_group_name = "rg-ddi-dev"
      location            = "westus"
      sku                 = "Standard" #[possible values : Standard,Gateway,Basic]
      sku_tier            = "Regional" #[possible values : Regional,Global]
      tags = { env = "dev"
        org = "ddi"
      }
      frontend_ip_configuration = [
        {
          name                          = "lb-pip-ddi-devone"
          zones                         = []
          public_ip_name                = null
          subnet_name                   = format("%s/%s", "vnet-ddi-dev", "sub-ddi-dev-web")
          private_ip_address_allocation = "Dynamic"
        }
      ]
    },
    {
      name                = "lb-ddi-poc"
      resource_group_name = "rg-ddi-poc"
      location            = "eastus"
      sku                 = "Gateway" #[possible values : Standard,Gateway,Basic]
      sku_tier            = "Regional" #[possible values : Regional,Global]
      tags = { env = "dev"
        org = "ddi"
      }
      frontend_ip_configuration = [
        {
          name                          = "lb-pip-ddi-poc"
          zones                         = [] #availability zone supported only with Standard SKU
          public_ip_name                = null
          subnet_name                   = format("%s/%s", "vnet-ddi-poc", "sub-ddi-poc-lb")
          private_ip_address_allocation = "Dynamic"
        }
      ]
    }

  ]
  
}

module "availability_set" {
  source                = "app.terraform.io/Motifworks/availability_set/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  availability_set_list = [
    {
      name                         = "ddiavailabilityset"
      resource_group_name          = "rg-ddi-dev"
      location                     = "westus"
      platform_fault_domain_count  = 3
      platform_update_domain_count = 5
      managed                      = true
      tags = {
        environment = "dev"
      }
    }
  ]
}
