module "resource_Group" {
  source  = "app.terraform.io/Motifworks/resource_Group/azurerm"
  version = "1.0.5"
  resource_group_list = [
    {
      name     = "rg-ddi-poc1"
      location = "eastus"
      tags = {
        location     = "eastus"
        subscription = "iac-dev"
        environment  = "poc"
      }
    },
    {
      name     = "rg-ddi-dev1"
      location = "westus"
      tags = {
        location     = "westus"
        subscription = "iac-dev"
        environment  = "dev"
      }
    }
  ]
}
# module "private_dns_zone" {
#   source                = "app.terraform.io/Motifworks/private_dns_zone/azurerm"
#   version               = "1.0.1"
#   resource_group_output = module.resource_Group.resource_group_output
#   private_dns_zone_list = [
#     {
#       name                = "private.com"
#       resource_group_name = "rg-ddi-poc1"
#       tags = {
#         location     = "westus"
#         subscription = "iac-dev"
#         environment  = "dev"
#       }
#     }
#   ]
# }
# module "dns_zone" {
#   source                = "app.terraform.io/Motifworks/dns-zone/azurerm"
#   version               = "1.0.1"
#   resource_group_output = module.resource_Group.resource_group_output
#   dns_zone_list = [
#     {
#       name                = "private.com"
#       resource_group_name = "rg-ddi-poc1"
#       tags = {
#         location     = "westus"
#         subscription = "iac-dev"
#         environment  = "dev"
#       }
#     }
#   ]
# }
module "azurerm_cdn_frontdoor_profile" {
  source  = "app.terraform.io/Motifworks/azurerm_cdn_frontdoor_profile/azurerm"
  version = "1.0.2"

  cdn_frontdoor_profile_list = [
    {
      name                = "test-frontdoor"
      location            = "westus"
      resource_group_name = "rg-ddi-dev1"
      sku_name            = "Standard_AzureFrontDoor"
      tags = {
        location     = "eastus"
        subscription = "iac-dev"
        environment  = "poc"
      }
    }
  ]
  depends_on = [module.resource_Group]
}
module "cdn_frontdoor_rule_set" {
  source                       = "app.terraform.io/Motifworks/cdn_frontdoor_rule_set/azurerm"
  version                      = "1.0.1"
  cdn_frontdoor_profile_output = module.azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile_output
  cdn_frontdoor_rule_set_list = [
    {
      name             = "ruleset"
      cdn_profile_name = "test-frontdoor"
    }
  ]
  depends_on = [module.azurerm_cdn_frontdoor_profile]
}
module "cdn_frontdoor_custom_domain" {
  source                                = "app.terraform.io/Motifworks/cdn_frontdoor_custom_domain/azurerm"
  version                               = "1.0.1"
  cdn_endpoint_frontdoor_profile_output = module.azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile_output
  cdn_endpoint_custom_domain_list = [
    {
      name                       = "admin2re"
      cdn_frontdoor_profile_name = "test-frontdoor"
      host_name                  = "adminw2.talentportal.ddiworld.com"
      tls = [
        {
          certificate_type    = "ManagedCertificate"
          minimum_tls_version = "TLS12"
        }
      ]
    }
  ]
}
module "cdn_frontdoor_endpoint" {
  source                       = "app.terraform.io/Motifworks/cdn_frontdoor_endpoint/azurerm"
  version                      = "1.0.1"
  cdn_frontdoor_profile_output = module.azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile_output
  cdn_frontdoor_endpoint_list = [{
    name                       = "fd-ddi-demo-endpoint-eastus-001"
    cdn_frontdoor_profile_name = "test-frontdoor"
    enabled                    = true
    tags = {
      env = "dev"
    }
  }]
}
module "cdn_frontdoor_origin_group" {
  source                       = "app.terraform.io/Motifworks/cdn-frontdoor_origin_group/azurerm"
  version                      = "1.0.1"
  cdn_frontdoor_profile_output = module.azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile_output
  cdn_frontdoor_origin_group_list = [
    {
      name                       = "origin-added"
      cdn_frontdoor_profile_name = "test-frontdoor"
      session_affinity_enabled   = false
      health_probe = [
        {
          interval_in_seconds = 50
          path                = "/"
          protocol            = "Http"
          request_type        = "HEAD"
        }
      ]
      load_balancing = [
        {
          additional_latency_in_milliseconds = 50
          sample_size                        = 4
          successful_samples_required        = 3
        }
      ]
    }
  ]
}
module "cdn_frontdoor_origin" {
  source                            = "app.terraform.io/Motifworks/cdn_frontdoor_origin/azurerm"
  version                           = "1.0.1"
  cdn_frontdoor_origin_group_output = module.cdn_frontdoor_origin_group.cdn_frontdoor_origin_group_output
  cdn_frontdoor_origin_list = [
    {
      name                            = "origingrip"
      cdn_frontdoor_origin_group_name = "origin-added"
      enabled                         = true
      certificate_name_check_enabled  = false
      host_name                       = "fdplatform.ddiworld.com"
      http_port                       = 80
      https_port                      = 443
      origin_host_header              = "fdplatform.ddiworld.com"
      priority                        = 1
      weight                          = 1000
      private_link                    = []

    }
  ]
}
# module "cdn_frontdoor_origin" {
#   source  = "app.terraform.io/Motifworks/cdn_frontdoor_origin/azurerm"
#   version = "1.0.1"
#   cdn_frontdoor_profile_output = module.cdn_frontdoor_origin_group.cdn_frontdoor_origin_group_output
#   cdn_frontdoor_origin_list = [
#    {
#   name                             = "origingrip"                          
#   cdn_frontdoor_origin_group_name = "origin-added"
#   enabled                          = "Disabled"  							
#   certificate_name_check_enabled   = false					
#   host_name                        = "fdplatform.ddiworld.com"                    
#   http_port                        = 80                 
#   https_port                       = 443                    
#   origin_host_header               = "fdplatform.ddiworld.com"        
#   priority                         = 1                      
#   weight                           = 1000

#    }
#   ]
# }

module "window_vm" {
  source                        = "app.terraform.io/Motifworks/window-vm/azurerm"
  version                       = "1.0.3"
  network_interface_card_output = module.network_interface_card.network_interface_card_output
  windows_vm_list = [
    {
      name : "vm-windows"
      resource_group_name             = "rg-ddi-dev1"
      location                        = "westus"
      size                            = "Standard_F2"
      disable_password_authentication = false
      allow_extension_operations      = true
      availability_set_name           = null
      network_interface_card_name     = ["nic1"]
      admin_username                  = "adminuser"
      admin_password                  = "P@$$w0rd1234!"
      #  network_interface_ids = [
      #   "/subscriptions/8694217e-4a30-4107-9a12-aeac74b82f5c/resourceGroups/rg-ddi-dev1/providers/Microsoft.Network/networkInterfaces/nic1"
      #  ]
      os_disk = [
        {
          name                 = "testing"
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
        }
      ]

      source_image_reference = [
        {
          publisher = "MicrosoftWindowsServer"
          offer     = "WindowsServer"
          sku       = "2016-Datacenter"
          version   = "latest"
        }
      ]
    }
  ]
}
module "linux_vm" {
  source                        = "app.terraform.io/Motifworks/linux-vm/azurerm"
  version                       = "1.0.0"
  network_interface_card_output = module.network_interface_card.network_interface_card_output

  linux_vm_list = [
    {
      name : "vm1-linux"
      resource_group_name             = "rg-ddi-dev1"
      location                        = "westus"
      size                            = "Standard_F2"
      disable_password_authentication = false
      allow_extension_operations      = true
      availability_set_name           = null
      network_interface_card_name     = ["vm1-linux-nic"]
      admin_username                  = "adminuser"
      admin_password                  = "P@$$w0rd1234!"
      tags = {
        location     = "eastus"
        subscription = "iac-dev"
        environment  = "poc"
      }
      #  network_interface_ids = [
      #   "/subscriptions/8694217e-4a30-4107-9a12-aeac74b82f5c/resourceGroups/rg-ddi-dev1/providers/Microsoft.Network/networkInterfaces/1"
      #  ]
      os_disk = [
        {
          name                 = "testing2"
          caching              = "ReadWrite"
          storage_account_type = "Standard_LRS"
        }
      ]

      source_image_reference = [
        {
          publisher = "Canonical"
          offer     = "0001-com-ubuntu-server-jammy"
          sku       = "22_04-lts"
          version   = "latest"
        }
      ]
    }
  ]
}

module "virtual_network" {
  source                = "app.terraform.io/Motifworks/virtual_network/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  virtual_network_list = [
    {
      name                = "vnet-ddi-poc1"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc1"
      address_space       = ["10.100.0.0/20"] //["172.21.0.0/16"]  
      tags = {
        environment = "poc"
      }
    },
    {
      name                = "vnet-ddi-dev1"
      location            = "westus"
      resource_group_name = "rg-ddi-dev1"
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
      resource_group_name                           = "rg-ddi-poc1"
      virtual_network_name                          = "vnet-ddi-poc1"
      address_prefixes                              = ["10.100.0.0/24"]
      service_endpoints                             = ["Microsoft.Storage"]
      service_endpoint_policy_ids                   = [] # compulsury input value needed otherwise module will throw error #["/subscriptions/8694217e-4a30-4107-9a12-aeac74b82f5c/resourceGroups/rg-ddi-poc1/providers/Microsoft.Network/serviceEndpointPolicies/ddi-test-poc/"]
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
      resource_group_name                           = "rg-ddi-dev1"
      virtual_network_name                          = "vnet-ddi-dev1"
      address_prefixes                              = ["10.100.16.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.Web"]
      service_endpoint_policy_ids                   = ["ddi-sep-dev"]
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },
    {
      name                                          = "sub-ddi-dev2-web"
      resource_group_name                           = "rg-ddi-dev1"
      virtual_network_name                          = "vnet-ddi-dev1"
      address_prefixes                              = ["10.100.18.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.Web"]
      service_endpoint_policy_ids                   = []
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },
    {
      name                                          = "sub-ddi-poc-lb"
      resource_group_name                           = "rg-ddi-poc1"
      virtual_network_name                          = "vnet-ddi-poc1"
      address_prefixes                              = ["10.100.2.0/24"]
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },
        {
      name                                          = "sub-ddi-poc-appgw"
      resource_group_name                           = "rg-ddi-poc1"
      virtual_network_name                          = "vnet-ddi-poc1"
      address_prefixes                              = ["10.100.3.0/24"]
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },
    {
      name                                          = "GatewaySubnet"
      resource_group_name                           = "rg-ddi-poc1"
      virtual_network_name                          = "vnet-ddi-poc1"
      address_prefixes                              = ["10.100.1.0/24"]
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    },

    {
      name                                          = "GatewaySubnet"
      resource_group_name                           = "rg-ddi-dev1"
      virtual_network_name                          = "vnet-ddi-dev1"
      address_prefixes                              = ["10.100.17.0/24"]
      service_endpoints                             = []
      service_endpoint_policy_ids                   = []
      private_endpoint_network_polices_enabled      = "false"
      private_link_service_network_policies_enabled = "false"

      delegation = []
    }

  ]
  depends_on = [module.virtual_network]
}

module "service_endpoint_policy" {
  source                 = "app.terraform.io/Motifworks/service_endpoint_policy/azurerm"
  version                = "1.0.0"
  resource_group_output  = module.resource_Group.resource_group_output
  storage_account_output = module.storage_account.storage_account_output
  service_endpoint_policy_list = [
    # {
    #   name                = "ddi-sep-poc"
    #   resource_group_name = "rg-ddi-poc1"
    #   location            = "eastus"

    #   definition = [
    #     {
    #       name              = "spe-stg-ddi-poc"
    #       description       = "poc policy"
    #       service           = "Microsoft.Storage"
    #       service_resources = [module.resource_Group.resource_group_output["rg-ddi-poc1"].id]

    #     }

    #   ]
    # },
    {
      name                = "ddi-sep-dev"
      resource_group_name = "rg-ddi-dev1"
      location            = "westus"

      definition = [
        {
          name              = "spe-stg-ddi-dev"
          description       = "poc policy"
          service           = "Microsoft.Storage"
          service_resources = [module.resource_Group.resource_group_output["rg-ddi-dev1"].id] #module.storage_account.storage_account_output["ddistorageacc"].id

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
      resource_group_name = "rg-ddi-poc1"
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
    #   resource_group_name = "rg-ddi-poc1"
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
      resource_group_name = "rg-ddi-dev1"

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
      virtual_network_name = "vnet-ddi-poc1"
      dns_servers          = ["10.168.10.1"]
    },
    {
      virtual_network_name = "vnet-ddi-dev1"
      dns_servers          = []
    }
  ]
  depends_on = [module.virtual_network]
}

module "public_ip" {
  source                = "app.terraform.io/Motifworks/public_ip/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  public_ip_list = [
    {
      name                = "publicip-ddi-poc"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc1"
      allocation_method   = "Dynamic"
      sku                 = "Basic"
      zones               = []
      domain_name_label   = "unique-testing-label-one"
      tags = {
        environment = "poc"
      }
      sku_tier = "Regional"
    },
        {
      name                = "publicip-ddi-appgw"
      location            = "eastus"
      resource_group_name = "rg-ddi-poc1"
      allocation_method   = "Static"
      sku                 = "Standard"
      zones               = [1,2]
      domain_name_label   = null
      tags = {
        environment = "poc"
      }
      sku_tier = "Regional"
    },
    {
      name                = "public-ip-ddi-dev"
      location            = "westus"
      resource_group_name = "rg-ddi-dev1"
      allocation_method   = "Static"
      sku                 = "Basic"
      zones               = []
      domain_name_label   = "another-unique-label-one"
      tags = {
        environment = "dev"
      }
      sku_tier = "Regional"
    },
    {
      name                = "public-ip-ddi-dev2"
      location            = "westus"
      resource_group_name = "rg-ddi-dev1"
      allocation_method   = "Static"
      sku                 = "Basic"
      zones               = []
      domain_name_label   = "officers-choice-label"
      tags = {
        environment = "dev"
      }
      sku_tier = "Regional"
    },
    {
      name                = "public-ip-ddi-lb"
      location            = "westus"
      resource_group_name = "rg-ddi-dev1"
      allocation_method   = "Static"
      sku                 = "Standard"
      zones               = []
      domain_name_label   = "one-lb-unique-label"
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
      resource_group_name = "rg-ddi-dev1"
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
      resource_group_name = "rg-ddi-dev1"
      tags = {
        environment = "dev"
      }
      ip_configuration = [
        {
          name                          = "config1"
          virtual_network_name          = "vnet-ddi-dev1"
          subnet_name                   = "sub-ddi-dev-web"
          private_ip_address_allocation = "Dynamic"
          public_ip_name                = "public-ip-ddi-dev"
          private_ip_address            = null
        }
      ]
    },

    {
      name                = "vm1-linux-nic"
      location            = "westus"
      resource_group_name = "rg-ddi-dev1"
      tags = {
        environment = "dev"
      }
      ip_configuration = [
        {
          name                          = "config2"
          virtual_network_name          = "vnet-ddi-dev1"
          subnet_name                   = "sub-ddi-dev2-web"
          private_ip_address_allocation = "Dynamic"
          public_ip_name                = "public-ip-ddi-dev2"
          private_ip_address            = null
        }
      ]
    },
    {
      name                = "lb-ddi-dev-nic"
      location            = "westus"
      resource_group_name = "rg-ddi-dev1"
      tags = {
        environment = "dev"
      }
      ip_configuration = [
        {
          name                          = "lb-ddi-dev-ip"
          virtual_network_name          = "vnet-ddi-dev1"
          subnet_name                   = "sub-ddi-dev-web"
          private_ip_address_allocation = "Dynamic"
          public_ip_name                = null
          private_ip_address            = null
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

  association_list = [
    {
      nsg_name  = "nsg-ddi-poc"
      subnet_id = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-web") #
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
      subnet_id        = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-web")
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
      network_interface_card_name = format("%s/%s", "rg-ddi-dev1", "nic1")
    }
  ]
}

module "keyvault" {
  source  = "app.terraform.io/Motifworks/keyvault/azurerm"
  version = "1.0.6"

  key_vault_list = [
    {
      name                = "testiefngkvrss2"
      resource_group_name = "rg-ddi-dev1"
      location            = "westus"

      sku_name                        = "standard"
      tenant_id                       = "fd41ee0d-0d97-4102-9a50-c7c3c5470454"
      enabled_for_deployment          = true
      enabled_for_disk_encryption     = false
      enabled_for_template_deployment = false
      enable_rbac_authorization       = false
      soft_delete_retention_days      = 7
      purge_protection_enabled        = false
      public_network_access_enabled   = true
      enable_rbac_authorization       = true
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
          secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
          storage_permissions     = ["Get", "Set", "Delete", "Update"]
        },
        {
          tenant_id : "fd41ee0d-0d97-4102-9a50-c7c3c5470454"
          object_id : "ea7d721a-3358-433d-b26f-1d79421f920d"
          resource_type           = "user"
          application_id          = null
          certificate_permissions = ["Get", "Create", "Delete", "Update"]
          key_permissions         = ["Get", "Create", "Delete", "Update"]
          secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
          storage_permissions     = ["Get", "Set", "Delete", "Update"]
        },
        {
          tenant_id : "fd41ee0d-0d97-4102-9a50-c7c3c5470454"
          object_id : "c5a7e9ba-7140-4953-b220-f84706a36eea"
          resource_type           = "user"
          application_id          = null
          certificate_permissions = ["Get", "Create", "Delete", "Update"]
          key_permissions         = ["Get", "Create", "Delete", "Update"]
          secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
          storage_permissions     = ["Get", "Set", "Delete", "Update"]
        }
      ]

      #       #       contact = [
      #       #         {
      #       #           email = "Vijay.Yadav@motifworks.com"
      #       #           name  = "Vijay Yadav"
      #       #           phone = "93042322"
      #       #         }
      #       #       ]

      tags = {
        env = "poc"
      }
    }
  ]
  depends_on = [module.resource_Group]

}

module "vault_secret" {
  source           = "app.terraform.io/Motifworks/vault_secret/key"
  version          = "1.0.0"
  key_vault_output = module.keyvault.key_vault_output
  key_vault_secret_list = [
    {
      name           = "secrauce"
      value          = "szechuan"
      key_vault_name = "testiefngkvrss2"

    }
  ]
  depends_on = [module.keyvault]
}


module "storage_account" {
  source                = "app.terraform.io/Motifworks/storage_account/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  subnet_output         = module.subnet.vnet_subnet_output


  storage_account_list = [
    {
      name                      = "ddistorageacc2"
      resource_group_name       = "rg-ddi-dev1"
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
          virtual_network_name = "vnet-ddi-dev1"
          subnet_name          = "sub-ddi-dev-web"
        }
      ]
    },

    {
      name                      = "ddistorageaccone"
      resource_group_name       = "rg-ddi-dev1"
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
        # {
        #   default_action       = "Allow"
        #   bypass               = ["AzureServices"]
        #   ip_rules             = ["23.45.1.0/30"]
        #   virtual_network_name = "vnet-ddi-dev1"
        #   subnet_name          = "sub-ddi-dev-web"
        # }
      ]
    }
  ]
}
module "useridentity" {
  source  = "app.terraform.io/Motifworks/useridentity/azurerm"
  version = "1.0.2"

  user_assigned_identity_list = [
    {
      name = "user-managed24"
      resource_group_name = "rg-ddi-dev1"
      location            = "eastus"
      tags = {
        environment = "nertwork-team"
      }
    },
    {
      name = "ddi-appgw-identity"
      resource_group_name = "rg-ddi-poc1"
      location            = "eastus"
      tags = {
        environment = "nertwork-team"
      }
    }
  ]
  depends_on = [module.resource_Group]
}

module "managed_disk" {
  source                = "app.terraform.io/Motifworks/managed_disk/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  managed_disk_list = [
    {
      name                 = "ddidisk1"
      resource_group_name  = "rg-ddi-dev1"
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
      resource_group_name = "rg-ddi-dev1"
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
      resource_group_name = "rg-ddi-dev1"
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
          subnet_name                   = format("%s/%s", "vnet-ddi-dev1", "sub-ddi-dev-web")
          private_ip_address_allocation = "Dynamic"
        }
      ]
    },
    {
      name                = "lb-ddi-poc"
      resource_group_name = "rg-ddi-poc1"
      location            = "eastus"
      sku                 = "Gateway"  #[possible values : Standard,Gateway,Basic]
      sku_tier            = "Regional" #[possible values : Regional,Global]
      tags = { env = "dev"
        org = "ddi"
      }
      frontend_ip_configuration = [
        {
          name                          = "lb-pip-ddi-poc"
          zones                         = [] #availability zone supported only with Standard SKU
          public_ip_name                = null
          subnet_name                   = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-lb")
          private_ip_address_allocation = "Dynamic"
        }
      ]
    }

  ]

}

module "loadbalancer_backend_pool" {
  source               = "app.terraform.io/Motifworks/loadbalancer_backend_pool/azurerm"
  version              = "1.0.0"
  load_balancer_output = module.load_balancer.load_balancer_output
  #virtual_network_output = module.virtual_network.virtual_network_output

  backend_pool_list = [
    {
      name              = "bkp-lb-ddi-dev"
      loadbalancer_name = "lb-ddi-devone"
      #virtual_network_name = "vnet-ddi-dev1"
      tunnel_interface = []
    },
    {
      name              = "bkp-lb-ddi-dev"
      loadbalancer_name = "lb-ddi-dev"
      #virtual_network_name = "vnet-ddi-dev1"
      tunnel_interface = []
    },
    {
      name              = "bkp-lb-ddi-dev1"
      loadbalancer_name = "lb-ddi-dev"
      #virtual_network_name = "vnet-ddi-dev1"
      tunnel_interface = []
    },
    {
      name              = "bkp-lb-ddi-poc"
      loadbalancer_name = "lb-ddi-poc"
      #virtual_network_name  = "vnet-ddi-poc1"
      tunnel_interface = [
        {
          identifier = "800"
          type       = "Internal"
          protocol   = "VXLAN"
          port       = "443"
        }
      ]
    },
    {
      name              = "bkp-lb-ddi-poc1"
      loadbalancer_name = "lb-ddi-poc"
      #virtual_network_name  = "vnet-ddi-poc1"
      tunnel_interface = [
        {
          identifier = "801"
          type       = "External"
          protocol   = "VXLAN"
          port       = "8080"
        }
      ]
    }

  ]
}

module "loadbalancer_backend_address_pool_addresses" {
  source  = "app.terraform.io/Motifworks/loadbalancer_backend_address_pool_addresses/azurerm"
  version = "1.0.0"

  lb_backend_address_pool_output = module.loadbalancer_backend_pool.lb_backend_address_pool_output
  virtual_network_output         = module.virtual_network.virtual_network_output

  lb_backend_address_pool_addresses_list = [
    {
      name                      = "lb-bkp-pool-ddi-dev-ip-name"
      backend_address_pool_name = format("%s/%s", "lb-ddi-devone", "bkp-lb-ddi-dev")
      virtual_network_name      = "vnet-ddi-dev1"
      ip_address                = "10.100.16.10"
    },
    {
      name                      = "lb-bkp-pool-ddi-poc-ip-name"
      backend_address_pool_name = format("%s/%s", "lb-ddi-poc", "bkp-lb-ddi-poc")
      virtual_network_name      = "vnet-ddi-poc1"
      ip_address                = "10.100.2.10"
    }

  ]
  depends_on = [module.load_balancer, module.loadbalancer_backend_pool, module.resource_Group]
}

module "loadbancer_backend_nic_association" {
  source                         = "app.terraform.io/Motifworks/loadbancer_backend_nic_association/azurerm"
  version                        = "1.0.0"
  lb_backend_address_pool_output = module.loadbalancer_backend_pool.lb_backend_address_pool_output
  network_interface_card_output  = module.network_interface_card.network_interface_card_output

  lb_bckpool_nic_association_list = [
    {
      network_interface_card_name  = format("%s/%s", "rg-ddi-dev1", "lb-ddi-dev-nic")
      ip_configuration_name        = "lb-ddi-dev-ip"
      lb_backend_address_pool_name = format("%s/%s", "lb-ddi-dev", "bkp-lb-ddi-dev")
    }
  ]
  depends_on = [module.resource_Group, module.loadbalancer_backend_pool]
}

module "loadbalancer_health_probe" {
  source               = "app.terraform.io/Motifworks/loadbalancer_health_probe/azurerm"
  version              = "1.0.0"
  load_balancer_output = module.load_balancer.load_balancer_output

  lb_health_probe_list = [
    {
      name                = "lb-hp-ddi-dev"
      load_balancer_name  = "lb-ddi-dev"
      protocol            = "Http"
      port                = "80"
      probe_threshold     = "5"
      request_path        = "/"
      interval_in_seconds = "5"
      number_of_probes    = "3"
    },
    {
      name                = "lb-hp-ddi-devone"
      load_balancer_name  = "lb-ddi-devone"
      protocol            = "Https"
      port                = "443"
      probe_threshold     = "5"
      request_path        = "/app"
      interval_in_seconds = "5"
      number_of_probes    = "3"
    },
    {
      name                = "lb-hp-ddi-poc"
      load_balancer_name  = "lb-ddi-poc"
      protocol            = "Https"
      port                = "443"
      probe_threshold     = "5"
      request_path        = "/app"
      interval_in_seconds = "5"
      number_of_probes    = "3"
    }
  ]

  depends_on = [module.load_balancer]
}

module "loadbalancer_nat_pool" {
  source                = "app.terraform.io/Motifworks/loadbalancer_nat_pool/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  load_balancer_output  = module.load_balancer.load_balancer_output

  lb_nat_pool_list = [
    {
      name                           = "lb-nat-ddi-dev"
      resource_group_name            = "rg-ddi-dev1"
      loadbalancer_name              = "lb-ddi-dev"
      protocol                       = "Tcp" # [All, Tcp, Udp]
      frontend_port_start            = "80"
      frontend_port_end              = "81"
      backend_port                   = "8080"
      frontend_ip_configuration_name = "lb-pip-ddi-dev"
      idle_timeout_in_minutes        = "4"     #[ 4 to 30] idle is 4
      floating_ip_enabled            = "false" #Required to configure a SQL AlwaysOn Availability Group
      tcp_reset_enabled              = "false"
    }
  ]
  depends_on = [module.load_balancer, module.resource_Group]
}


module "loadbalancer_outbound_rule" {
  source                         = "app.terraform.io/Motifworks/loadbalancer_outbound_rule/azurerm"
  version                        = "1.0.0"
  load_balancer_output           = module.load_balancer.load_balancer_output
  lb_backend_address_pool_output = module.loadbalancer_backend_pool.lb_backend_address_pool_output

  lb_outbound_rule_list = [
    {
      name                      = "lb-ddi-dev-outbound-rule"
      loadbalancer_name         = "lb-ddi-dev"
      protocol                  = "All" # [All, Tcp , Udp]
      backend_address_pool_name = format("%s/%s", "lb-ddi-dev", "bkp-lb-ddi-dev")
      enable_tcp_reset          = false
      allocated_outbound_ports  = "8" # Default numbers allowed 1024
      idle_timeout_in_minutes   = "4" # Default is 4
      frontend_ip_configuration = [
        {
          name = "lb-pip-ddi-dev"
        }
      ]

    },
    # {
    # name = "lb-ddi-devone-outbound-rule"
    # loadbalancer_name = "lb-ddi-devone" 
    # protocol = "Tcp"  # [All, Tcp , Udp]
    # backend_address_pool_name = format("%s/%s", "lb-ddi-devone", "bkp-lb-ddi-dev")
    # enable_tcp_reset = true
    # allocated_outbound_ports = "9" # Default numbers allowed 1024
    # idle_timeout_in_minutes = "5" # Default is 4
    # frontend_ip_configuration = [
    #   {
    #     name  = "lb-pip-ddi-devone"
    #   }
    # ]

    # }
  ]
  depends_on = [module.load_balancer, module.loadbalancer_backend_pool]
}


module "loadbalancer_rule" {
  source                         = "app.terraform.io/Motifworks/loadbalancer_rule/azurerm"
  version                        = "1.0.0"
  load_balancer_output           = module.load_balancer.load_balancer_output
  lb_backend_address_pool_output = module.loadbalancer_backend_pool.lb_backend_address_pool_output
  lb_health_probe_output         = module.loadbalancer_health_probe.lb_health_probe_output

  lb_rule_list = [
    {
      name                           = "lb-ddi-dev-rule"
      loadbalancer_name              = "lb-ddi-dev"
      protocol                       = "Tcp" #[All , Tcp , Udp]
      frontend_port                  = 80
      backend_port                   = 80
      frontend_ip_configuration_name = "lb-pip-ddi-dev"
      health_probe_name              = "lb-hp-ddi-dev"
      enable_floating_ip             = false     #Required to configure a SQL AlwaysOn Availability Group: true
      idle_timeout_in_minutes        = 4         #between 4 to 30
      load_distribution              = "Default" # possible values [Default ,SourceIP, SourceIPProtocol, None ,Client IP, Client IP and Protocol]
      disable_outbound_snat          = true
      enable_tcp_reset               = false
      backend_address_pool_ids       = [module.loadbalancer_backend_pool.lb_backend_address_pool_output["lb-ddi-dev/bkp-lb-ddi-dev"].id] #only Gateway SKU Load Balancer can have more than one "backend_address_pool_ids"
    },
    {
      name                           = "lb-ddi-poc-rule"
      loadbalancer_name              = "lb-ddi-poc"
      protocol                       = "All" #[All , Tcp , Udp]
      frontend_port                  = 0
      backend_port                   = 0
      frontend_ip_configuration_name = "lb-pip-ddi-poc"
      health_probe_name              = "lb-hp-ddi-poc"
      enable_floating_ip             = false     #Required to configure a SQL AlwaysOn Availability Group: true
      idle_timeout_in_minutes        = 4         #between 4 to 30
      load_distribution              = "Default" # possible values [Default ,SourceIP, SourceIPProtocol, None ,Client IP, Client IP and Protocol]
      disable_outbound_snat          = false
      enable_tcp_reset               = false
      backend_address_pool_ids       = [module.loadbalancer_backend_pool.lb_backend_address_pool_output["lb-ddi-poc/bkp-lb-ddi-poc"].id, module.loadbalancer_backend_pool.lb_backend_address_pool_output["lb-ddi-poc/bkp-lb-ddi-poc1"].id] #only Gateway SKU Load Balancer can have more than one "backend_address_pool_ids"
    }
  ]
  depends_on = [module.load_balancer, module.loadbalancer_backend_pool, module.loadbalancer_health_probe]
}




module "availability_set" {
  source                = "app.terraform.io/Motifworks/availability_set/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  availability_set_list = [
    {
      name                         = "ddiavailabilityset"
      resource_group_name          = "rg-ddi-dev1"
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

module "management_lock" {
  source                 = "app.terraform.io/Motifworks/management_lock/azurerm"
  version                = "1.0.0"
  virtual_network_output = module.virtual_network.virtual_network_output
  subnet_output          = module.subnet.vnet_subnet_output

  management_lock_list = [
    {

      name                 = "ddiresourceip"
      resource_type        = "virtual_network"
      virtual_network_name = "vnet-ddi-dev1"
      lock_level           = "CanNotDelete"
      notes                = "Locked because it's needed by a third-party"
    }
  ]
}

module "traffic_manager_profile" {
  source                = "app.terraform.io/Motifworks/traffic_manager_profile/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output

  traffic_manager_profile_list = [
    {
      name                   = "dditestprofile"
      resource_group_name    = "rg-ddi-dev1"
      traffic_routing_method = "Weighted"

      dns_config = [
        {
          relative_name = "dev-app-one-one"
          ttl           = 100
        }
      ]

      monitor_config = [
        {
          protocol                     = "HTTP"
          port                         = 80
          path                         = "/"
          interval_in_seconds          = 30
          timeout_in_seconds           = 9
          tolerated_number_of_failures = 3
        }
      ]

      tags = {
        environment = "Production"
      }
    }
  ]
}

module "private_endpoint" {
  source                = "app.terraform.io/Motifworks/private_endpoint/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  # virtual_network_output = module.virtual_network.virtual_network_output
  subnet_output          = module.subnet.vnet_subnet_output
  storage_account_output = module.storage_account.storage_account_output

  private_endpoint_list = [
    {
      name                 = "privateendpoint1"
      resource_group_name  = "rg-ddi-dev1"
      location             = "westus"
      virtual_network_name = "vnet-ddi-dev1"
      subnet_name          = "sub-ddi-dev-web"
      storage_account_name = "ddistorageacc2"
      subresource_name     = ["blob"]
      tags = {
        environment = "dev"
      }
    }
  ]
}

module "private_link_service" {
  source                = "app.terraform.io/Motifworks/private_link_service/azurerm"
  version               = "1.0.0"
  resource_group_output = module.resource_Group.resource_group_output
  subnet_output         = module.subnet.vnet_subnet_output

  private_link_service_list = [
    {
      name                = "privatelinkservice1"
      resource_group_name = "rg-ddi-dev1"
      location            = "westus"
      load_balancer_name  = "lb-ddi-dev"
      tags = {
        environment = "dev"
      }
      nat_ip_configuration = [
        {
          name                       = "nat-config-1"
          private_ip_address         = "10.0.1.5"
          private_ip_address_version = "IPv4"
          virtual_network_name          = "vnet-ddi-dev1"
          subnet_name                = "sub-ddi-dev-web"
      }]
    }
  ]
}

# module "application_gateway" {
#   source  = "app.terraform.io/Motifworks/application_gateway/azurerm"
#   version = "1.0.0"
 
#   resource_group_output = module.resource_Group.resource_group_output
#   subnet_output         = module.subnet.vnet_subnet_output
#   public_ip_output      = module.public_ip.public_ip_output
#   user_assigned_identity_output = module.useridentity.user_assigned_identity_output


#   application_gateway_list = [
#     {
#       name                      = "appgw-ddi-poc"
#       resource_group_name       = "rg-ddi-poc1"
#       location                  = "eastus"
#       tags                      = {
#                                     env = "poc"
#                                     location = "eastus" },
#       web_application_firewall_name = null // name is required when WAf is enabled.
      
#       sku = {
#         name = "WAF_v2"  // possible values : Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2 //
#         tier  = "WAF_v2" // possible values : Standard, Standard_v2, WAF and WAF_v2 //
#         capacity = 0
#       }

#       autoscale_configuration = {
#       min_capacity  = "1"
#       max_capacity  = "3"
#     }

#       enable_http2 = "false"
#       zones   = [1,2]

#       gateway_ip_configuration = {
#         name      = "gateway-ip-config"
#         subnet_name = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-appgw")
#       }

#       frontend_ip_configuration = [
#         {
#           name    = "frnt-public-ip-ddi"
#           subnet_name = null
#           private_ip_address = null
#           public_ip_name= "publicip-ddi-appgw"
#           private_ip_address_allocation = null
#           private_link_configuration_name = null
#         },
#         {
#           name    = "frnt-private-ip-ddi"
#           subnet_name = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-appgw")
#           private_ip_address = "10.100.3.5"
#           public_ip_name = null
#           private_ip_address_allocation = "Static"  // always be static
#           private_link_configuration_name = "pvt-link-appgw"
#         }
#       ]

#       backend_address_pool = [
#         {
#         name = "bkp-ddi-app-fqdn"
#         fqdns = ["app-ddi-dev.cloudservice.microsoft.net", "app-ddi-dev2.cloudservice.microsoft.net"]
#         ip_addresses = null
#         },
#         {
#         name = "bkp-ddi-app-vm"
#         fqdns = null
#         ip_addresses = ["10.100.0.5" , "10.100.0.6"]
#         }
#       ]

#     backend_http_settings = [
#       {
#         name  = "bkp-http-ddi-app-fqdn-settings"
#         cookie_based_affinity = "Enabled"   // possible ["Enabled" "Disabled"]
#         affinity_cookie_name  = "affinity cookie"
#         path  = "/"
#         port  = "80"
#         probe_name  = "probe-app-fqdn-http"
#         protocol  = "Http"    //Http or Https
#         request_timeout  = "30"
#         host_name = "app-ddi-dev.com"
#         pick_host_name_from_backend_address = null   // true or false
#         trusted_root_certificate_names    = null
#         connection_draining = {
#           enabled   = false     // true or false
#           drain_timeout_sec = "3" // possible range (1 - 3600)
#         }
#       },
#       {
#         name  = "bkp-http-ddi-app-vm-settings"
#         cookie_based_affinity = "Enabled"   //possible ["Enabled" "Disabled"]
#         affinity_cookie_name  = "affinity cookie"
#         path  = "/"
#         port  = "80"
#         probe_name  = "probe-app-vm-http"
#         protocol  = "Http"   //Http or Https
#         request_timeout  = "30"
#         host_name = ".*.ddi-qa.com"
#         pick_host_name_from_backend_address = null  // true or false
#         trusted_root_certificate_names    = null
#         connection_draining = {
#           enabled   = true
#           drain_timeout_sec = "5"  // possible range (1 - 3600)
#         }
#       }      
#     ]

#     http_listener = [
#        {
#         name    = "listener-http-fqdns"
#         frontend_ip_configuration_name = "frnt-public-ip-ddi"
#         port  = 80
#         host_name   = "app-ddi-dev.com"
#         host_names  = null
#         protocol =  "Http"
#         listener_type = " "
#         ssl_certificate_name  = null
#         web_application_firewall_name  = null
#         custom_error_configuration = [
#           # {
#           #  status_code = "HttpStatus502"   //possible ["HttpStatus403" "HttpStatus502"]
#           #  custom_error_page_url  =  "https://ddiworld.com/error.html"
#           # }
#           ]  
#         },
#         {
#         name    = "listener-http-vm"
#         frontend_ip_configuration_name = "frnt-private-ip-ddi"
#         port  =  8080
#         host_name   = null
#         host_names  = [".*.ddi-qa.com"]
#         protocol =  "Http"
#         listener_type = " "
#         ssl_certificate_name  = null
#         web_application_firewall_name  = null
#         custom_error_configuration =[
#           # {
#           #  status_code = "HttpStatus502"  //possible ["HttpStatus403" "HttpStatus502"]
#           #  custom_error_page_url  =  "https://ddiworld.com/error.html"
#           # }
#         ]  
#         }

#     ]

#     identity = [
#       {
#         type  = "UserAssigned"
#         identity_ids  = [module.useridentity.user_assigned_identity_output["ddi-appgw-identity"].id]
#       }
#     ]
    

#     private_link_configuration = [
#       {
#       name  = "pvt-link-appgw"
#       ip_configuration = [
#         {
#       name = "pvt-link-appgw-ip"
#       subnet_name = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-appgw")
#       private_ip_address_allocation = "Dynamic"
#       primary = true
#       private_ip_address  = null
#       }
#       ]
#       }
#     ]

#     probe = [
#       {
#         name  = "probe-app-fqdn-http"
#         host  = "app-ddi-dev.com"
#         pick_host_name_from_backend_http_settings = null
#         interval  = "20"
#         protocol  = "Http"
#         path      = "/"
#         timeout   = "5"
#         unhealthy_threshold = "5"
#         port      = "80"
#         match= {
#           body      = null
#           status_code = [200,399]
#         }
#       },
#         {
#         name  = "probe-app-vm-http"
#         host  = null #".*.ddi-qa.com"
#         pick_host_name_from_backend_http_settings = true
#         interval  = "20"
#         protocol  = "Http"
#         path      = "/"
#         timeout   = "5"
#         unhealthy_threshold = "5"
#         port      = "80"
#         match= {
#           body      = null
#           status_code = [200,399]
#         }
#       }
#     ]

#     request_routing_rule  = [
#       {
#         name  = "http-fqdns-request"
#         rule_type = "Basic"   // Basic or PathBasedRouting
#         http_listener_name  = "listener-http-fqdns"
#         backend_address_pool_name = "bkp-ddi-app-fqdn"
#         backend_http_settings_name  = "bkp-http-ddi-app-fqdn-settings"
#         redirect_configuration_name = null
#         rewrite_rule_set_name = null
#         url_path_map_name = null // empty block when rule_type is basic
#         priority  = 101
#       },
#             {
#         name  = "http-vm-request"
#         rule_type = "Basic"   // Basic or PathBasedRouting
#         http_listener_name  = "listener-http-vm"
#         backend_address_pool_name = "bkp-ddi-app-vm"
#         backend_http_settings_name  = "bkp-http-ddi-app-vm-settings"
#         redirect_configuration_name = null
#         rewrite_rule_set_name = null
#         url_path_map_name = null // empty block when rule_type is basic
#         priority  = 102
#       }
#     ]

#     global  = {
#       request_buffering_enabled = true
#       response_buffering_enabled  = true
#     }

#     ssl_certificate = [
#     #   {
#     #     name =
#     #     Key_vault_name =
#     #     secret_name =
#     # }
#     ]

#     url_path_map = [
#       {
#         name = "path-based-url"
#         default_backend_address_pool_name = "bkp-ddi-app-vm"
#         default_backend_http_settings_name  = "bkp-http-ddi-app-vm-settings"
#         default_redirect_configuration_name = null
#         default_rewrite_rule_set_name = null
#         path_rule = [
#           {
#           name = "path-based-url-test"
#           paths = ["/test"]
#           backend_address_pool_name = "bkp-ddi-app-vm"
#           backend_http_settings_name  = "bkp-http-ddi-app-vm-settings"
#           redirect_configuration_name = null
#           rewrite_rule_set_name = null
#           web_application_firewall_name  = null
#         }
#         ]
#       }
      
#     ]
#     trusted_root_certificate = [
#       # {
#       #   name =
#       #   key_vault_secret_id =
#       # }
#     ]
     
#     waf_configuration = [
#       {
#         enabled = true
#         firewall_mode = "Detection"     #Detection and Prevention
#         rule_set_type = "OWASP"          #OWASP and Microsoft_BotManagerRuleSet
#         rule_set_version = "3.2"         #0.1, 1.0, 2.2.9, 3.0, 3.1 and 3.
#         file_upload_limit_mb  = "60"     #1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB
#         request_body_check    = true     #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#request_body_check
#         max_request_body_size_kb  = 128  #1KB to 128KB

#         disabled_rule_group = [
#          { rule_group_name = "REQUEST-944-APPLICATION-ATTACK-JAVA"    #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#rule_group_name
#           rules = []     # list name of rules to disbale. to disable all rules in a group paas empty list
#          }
#         ]

#         exclusion = [
#           {
#             match_variable = "RequestHeaderNames"   #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#match_variable
#             selector_match_operator = "Equals"      #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#selector_match_operator
#             selector  = "testhost" #null if you want to exclude for all match variable 
#           }
#         ]
#       }
#     ]

#     redirect_configuration = [
#       # {
#       #   name  = ""
#       #   redirect_type = ""
#       #   target_listener_name  = ""
#       #   target_url  = ""
#       #   include_path  = ""
#       #   include_query_string  ""
#       # }
#     ]


#     rewrite_rule_set = [
#       {
#         name = "rewrite_rule_set_test_name"
#         rewrite_rule =[
#           {
#             name  = "client_port_80_rule"
#             rule_sequence = 1
#             condition =[
#               {
#                 variable = "var_host" #https://learn.microsoft.com/en-us/azure/application-gateway/rewrite-http-headers-url#server-variables
#                 pattern  =  "sampleddi.com"
#                 ignore_case = true //true false
#                 negate  = false //true false
#               }
#             ]

#             request_header_configuration = [
#               {
#                 header_name = "X-isThroughProxy"
#                 header_value = "True"
#               }
#             ]

#             response_header_configuration = [
#               {
#                 header_name = "Strict-Transport-Security"
#                 header_value = "max-age=31536000"               
#               }
#             ]

#             url = [
#               {
#                 path =  "/artical.aspx"
#                 query_string = ".*article/(.*)/(.*)"  #One or both of path and query_string must be specified. If one of these is not specified, it means the value will be empty. If you only want to rewrite path or query_string, use components
#                 components = null   #path_only and query_string_only
#                 reroute = false     #Used to determine whether the URL path map is to be reevaluated or not. If not set, the original URL path will be used to match the path-pattern in the URL path map. If set, the URL path map will be reevaluated to check the match with the rewritten path.
#               }
#             ]

#           }
#         ]
#       }
#     ]

#     }
#   ]
  
# }