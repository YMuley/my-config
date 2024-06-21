azure_firewall_list = [
  {
    name                 = "fw-ddi-westus"
    resource_group_name  = "rg-ddi-dev1"
    location             = "westus"
    sku_name             = "AZFW_VNet"
    sku_tier             = "Premium"
    firewall_policy_name = "AfwP-ddi-westus"
    private_ip_ranges    = ["10.0.0.0/8"]
    zones                = []
    threat_intel_mode    = "Alert"

    ip_configuration = [
      {
        name                 = "ip-config-1"
        virtual_network_name = "vnet-ddi-dev1"
        subnet_name          = "AzureFirewallSubnet"
        public_ip_name       = "public-ip-ddi-fw"

      }
    ]

    tags = {
      environment = "dev"
    }
  }
]

azure_firewall_policy_list = [
  {
    name                              = "AfwP-ddi-westus"
    resource_group_name               = "rg-ddi-dev1"
    location                          = "westus"
    private_ip_ranges                 = ["10.0.0.0/16", "192.168.0.0/16"]
    auto_learn_private_ranges_enabled = true
    sku                               = "Premium"
    threat_intelligence_mode          = "Alert"
    sql_redirect_allowed              = true

    dns = [
      {
        proxy_enabled = false
        servers       = []
      }
    ]

    identity = [] //only premimum 


    insights = [
      {
        enabled                              = true
        default_log_analytics_workspace_name = "la-workspace-1"
        retention_in_days                    = 30
        log_analytics_workspace = [
          {
            log_analytics_workspace_name = "la-workspace-2"
            firewall_location            = "West US"
          },
          {
            log_analytics_workspace_name = "la-workspace-3"
            firewall_location            = "East US"
          }
        ]
      }
    ]

    # intrusion_detection = [ //only premimum
    #   {
    #     mode           = "Alert"
    #      private_ranges = ["192.168.1.0/24"]

    #     # signature_overrides = [
    #     #   {
    #     #     id    = ""      #12-digit number (id) which identifies your signature.
    #     #     state = "Alert" #state can be any of Off, Alert or Deny.
    #     #   }
    #     # ]

    #     traffic_bypass = [
    #       {
    #         name                  = "bypass-rule-1"
    #         protocol              = "TCP"
    #         description           = "Bypass rule description"
    #         destination_addresses = ["192.168.1.1"]
    #         destination_ports     = ["8080"]
    #       }
    #     ]
    #     private_ranges = []
    #   }
    # ]

    # tls_certificate = [
    #   {
    #     Key_vault_name        = "testiefngkvrss2"
    #     secret_name           = "secrauce"
    #     key_vault_secret_name = "cert-secret-name-1"
    #   }
    # ]

    # explicit_proxy = [
    #   {
    #     enabled         = true
    #     http_port       = 8080
    #     https_port      = 8443
    #     enable_pac_file = true
    #     pac_file_port   = 8888
    #     pac_file        = "http://example.com/proxy.pac"
    #   }
    # ]

    threat_intelligence_allowlist = [
      {
        fqdns        = ["allowed-domain.com"]
        ip_addresses = ["10.0.0.1"]
      }
    ]

    tags = {
      environment = "Production"
      project     = "FirewallProject"
    }
  }
]

# azure_firewall_application_rule_collection_list = [
#   {
#     name                = "firewall-rule-collection-1"
#     resource_group_name = "rg-ddi-dev1"
#     azure_firewall_name = "fw-ddi-westus"
#     priority            = 100
#     action              = "Allow"

#     rule_list = [
#       {
#         name             = "rule-1"
#         source_addresses = ["192.168.1.0/24"]
#         target_fqdns     = ["example.com", "contoso.com"]

#         protocol_list = [
#           {
#             port = 80
#             type = "Http"
#           },
#           {
#             port = 443
#             type = "Https"
#           }
#         ]
#       }
#     ]
#   },
#   {
#     name                = "firewall-rule-collection-2"
#     resource_group_name = "rg-ddi-dev1"
#     azure_firewall_name = "fw-ddi-westus"
#     priority            = 200
#     action              = "Deny"

#     rule_list = [
#       {
#         name             = "rule-2"
#         source_addresses = ["192.168.1.0/26"]
#         target_fqdns     = ["contoso.com"]

#         protocol_list = [
#           {
#             port = 80
#             type = "Http"
#           },
#           {
#             port = 443
#             type = "Https"
#           }
#         ]
#       }
#     ]
#   }
# ]

# azure_firewall_nat_rule_collection_list = [
#   {
#     name                = "nat-rule-collection-2"
#     resource_group_name = "rg-ddi-dev1"
#     azure_firewall_name = "fw-ddi-westus"
#     priority            = 101
#     action              = "Dnat"

#     rule_list = [
#       {
#         name                  = "rule-1"
#         source_addresses      = ["10.0.0.0/24"]
#         destination_addresses = ["10.100.19.4"]
#         destination_ports     = ["80"] //only single value is supported ,multiple value or ports will throw error
#         translated_address    = "192.168.1.1"
#         translated_port       = 443
#         protocols             = ["TCP"]
#       }
#     ]
#   }
# ]

# azure_firewall_network_rule_collection_list = [
#   {
#     name                = "network-rule-collection-1"
#     resource_group_name = "rg-ddi-dev1"
#     azure_firewall_name = "fw-ddi-westus"
#     priority            = 100
#     action              = "Deny"

#     rule_list = [
#       {
#         name                  = "rule-1-ddi"
#         source_addresses      = ["10.0.0.0/24"]
#         destination_addresses = ["13.64.185.194"]
#         destination_ports     = ["80"] //only single value is supported ,multiple value or ports will throw error
#         protocols             = ["TCP"]
#       }
#     ]
#   }
# ]

azure_firewall_policy_rule_collection_group_list = [
  {
    name                 = "Products-Development-NetworkRuleCollectionGroup"
    firewall_policy_name = "AfwP-ddi-westus"
    priority             = 500

    application_rule_collection_list = [
      {
        name     = "app_rule_collection1"
        priority = 500
        action   = "Deny"

        rule_list = [
          {
            name              = "app_rule_collection1_rule1"
            source_addresses  = ["10.0.0.1"]
            destination_fqdns = ["*.microsoft.com"]
            protocols_list = [
              {
                type = "Http"
                port = 80
              },
              {
                type = "Https"
                port = 443
              }
            ]
          }
        ]
      }
    ]

    network_rule_collection_list = [
      {
        name     = "application-gateway"
        priority = 100
        action   = "Allow"

        rule_list = [
          {
            name                  = "int-agw-to-gts-avd"
            protocols             = ["TCP"]
            source_addresses      = ["10.225.51.0/24"]
            destination_addresses = ["10.222.0.0/16"]
            # destination_ip_groups = ["ip-grp-spokes-int-agws"]
            destination_ports     = [80, 443]
            source_ip_groups      = []
            destination_fqdns     = []
          },
           {
            name                  = "dev-webs-to-agw"
            protocols             = ["TCP"]
            source_addresses      = ["10.225.10.0/24"]
            destination_addresses = ["10.225.50.0/24"]
            # destination_ip_groups = ["ip-grp-spokes-int-agws"]
            destination_ports     = [80, 443]
            source_ip_groups      = []
            destination_fqdns     = []
          }
        ]
      }
        ]
      },
  #  {
  #   name                 = "Products-Development-NetworkRuleCollectionGroup"
  #   firewall_policy_name = "AfwP-ddi-westus"
  #   priority             = 100

  #   network_rule_collection_list = [
      
  #   ]
  # }
]

subnet_nsg_association_list = [
  {
    nsg_name             = "nsg-ddi-poc"
    virtual_network_name = "vnet-ddi-poc1"
    subnet_name          = "sub-ddi-poc-web"
  },
  # {
  #   nsg_name             = "nsg-ddi-poc"
  #   virtual_network_name = "vnet-ddi-dev1"
  #   subnet_name          = "sub-ddi-dev-web"
  # }
]


subnet_route_table_association_list = [
  {
    route_table_name     = "rt-table1"
    virtual_network_name = "Vnet-ddi-poc1"
    subnet_name          = "Subnet1"
    resource_group_name  = "RG-YogeshMuley"
  },
  {
    route_table_name     = "rt-table2"
    virtual_network_name = "Vnet-ddi-poc1"
    subnet_name          = "Subnet2"
    resource_group_name  = "RG-YogeshMuley"
  },
  {
    route_table_name     = "rt-table3"
    virtual_network_name = "vnet-ddi-poc2"
    subnet_name          = "Subnet1"
    resource_group_name  = "RG-DDI-POC"
  },
  {
    route_table_name     = "rt-table3"
    virtual_network_name = "vnet-ddi-poc2"
    subnet_name          = "Subnet2"
    resource_group_name  = "RG-DDI-POC"
  }

]

terraform_subnet_route_table_association_list = [
  {
    route_table_name     = "rt-table4"
    virtual_network_name = "vnet-ddi-dev1"
    subnet_name          = "sub-ddi-dev-web"
  }
]


mssql_vm_list = [
  {
    virtual_machine_name             = "sql-server-vm" // name of windows machine where sql connection agent will be installed
    sql_license_type                 = "PAYG"          //AHUB (Azure Hybrid Benefit), DR (Disaster Recovery), and PAYG (Pay-As-You-Go)
    r_services_enabled               = true
    sql_connectivity_port            = "1433"
    sql_connectivity_type            = "PRIVATE" //LOCAL, PRIVATE and PUBLIC. Defaults to PRIVATE
    sql_connectivity_update_password = "Ddi@123456789"
    sql_connectivity_update_username = "ddiadmin"
    sql_virtual_machine_group_id     = null
    tags = {
      environment = "test"
    }
    auto_patching = [
      {
        day_of_week                            = "Sunday"
        maintenance_window_duration_in_minutes = "60"
        maintenance_window_starting_hour       = "2"
      }
    ]

    auto_backup = [
      {
        encryption_enabled       = false
        encryption_password      = ""
        retention_period_in_days = "30"
        storage_blob_endpoint    = "stgsqlddi" //In mssql_VM module we are fetching the primary blob endpoint of storage acct. If in case, want to use secondary endpoint modify the module code.
        // "storage_account_access_key" do not need to declare here. Module will fetch the primary access key using storage acc name. Go through the "terraform-azurerm-mssql-virtual-machine".
        system_databases_backup_enabled = "false"
        manual_schedule = [
          #   {
          #   full_backup_frequency  = "Weekly"                                   //Valid values include Daily or Weekly.
          #   full_backup_start_hour = "19"                                   //Valid values are from 0 to 23.
          #   full_backup_window_in_hours = "19"                              //Valid values are between 1 and 23.
          #   log_backup_frequency_in_minutes = "5"                          //Valid values are from 5 to 60.
          #   days_of_week  = ["Wednesday"]                                          //Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday and Sunday
          # }
        ]
      }
    ]

    key_vault_credential = [
      {
        name = "testiefngkvrss2"
        #   key_vault_url = ""
        service_principal_name   = "terraform cloud app reg"
        service_principal_secret = "LlW8Q~Slp36jMTSd81324Ionn5Wp-ubvhx2sUdlF"
      }
    ]


    sql_instance = [
      {
        adhoc_workloads_optimization_enabled = true
        collation                            = "SQL_Latin1_General_CP1_CI_AS"
        instant_file_initialization_enabled  = true   // Possible values are true and false. Defaults to false
        lock_pages_in_memory_enabled         = false  //Possible values are true and false. Defaults to false
        max_dop                              = "1000" //Possible values are between 0 and 32767. Defaults to 0
        max_server_memory_mb                 = "8064" //Possible values are between 128 and 2147483647 Defaults to 2147483647
        min_server_memory_mb                 = "4064" // Possible values are between 0 and 2147483647 Defaults to 0
      }
    ]

    storage_configuration = [
      {
        disk_type             = "NEW"     //Valid values include NEW, EXTEND, or ADD
        storage_workload_type = "GENERAL" //Valid values include GENERAL, OLTP, or DW

        data_settings = [
          {
            default_file_path = "F:\\data"
            luns              = ["0"]
          }
        ]

        log_settings = [
          {
            default_file_path = "L:\\log"
            luns              = ["1"]
          }
        ]
        system_db_on_data_disk_enabled = "false" // Possible values are true and false. Defaults to false

        temp_db_settings = [
          {
            default_file_path      = "T:\\tempDb"
            luns                   = ["2"]
            data_file_count        = "8"   //This value defaults to 8.                      
            data_file_size_mb      = "256" //This value defaults to 256.
            data_file_growth_in_mb = "512" //This value defaults to 512.
            log_file_size_mb       = "256" //This value defaults to 256.
            log_file_growth_mb     = "512" //This value defaults to 512.
          }
        ]
      }
    ]

    assessment = [
      {
        enabled         = "true"  //Defaults to true.
        run_immediately = "false" //Defaults to false.
        schedule = [
          {
            weekly_interval    = "0"         //Valid values are between 1 and 6.  #Either one of weekly_interval or monthly_occurrence must be specified.
            monthly_occurrence = "2"         //Valid values are between 1 and 5.
            day_of_week        = "Wednesday" //Possible values are Friday, Monday, Saturday, Sunday, Thursday, Tuesday and Wednesday.
            start_time         = "19:00"     //Must be in the format HH:mm.
          }
        ]
      }
    ]

    wsfc_domain_credential = [
      {
        cluster_bootstrap_account_password = "Dddi@123456789"
        cluster_operator_account_password  = "Dddi@123456789"
        sql_service_account_password       = "Dddi@123456789"
      }
    ]
  }
]

managed_disk_list = [
  {
    name                 = "data-disk-1"
    resource_group_name  = "rg-ddi-poc1"
    location             = "eastus"
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 1000
    tags = {
      environment = "dev"
    }
  },
  {
    name                 = "sql-log"
    resource_group_name  = "rg-ddi-poc1"
    location             = "eastus"
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 500
    tags = {
      environment = "dev"
    }
  },
  {
    name                 = "temp-db"
    resource_group_name  = "rg-ddi-poc1"
    location             = "eastus"
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 100
    tags = {
      environment = "dev"
    }
  }
]

vm_data_disk_attach_list = [
  {
    managed_disk_name = "data-disk-1"
    resource_type     = "windows" #linux or windows
    resource_name     = "sql-server-vm"
    lun               = "0"
    caching           = "ReadWrite"
  },
  {
    managed_disk_name = "sql-log"
    resource_type     = "windows" #linux or windows
    resource_name     = "sql-server-vm"
    lun               = "1"
    caching           = "ReadWrite"
  },
  {
    managed_disk_name = "temp-db"
    resource_type     = "windows" #linux or windows
    resource_name     = "sql-server-vm"
    lun               = "2"
    caching           = "ReadWrite"
  }
]


# application_gateway_list = [
#   {
#     name                = "appgw-ddi-poc"
#     resource_group_name = "rg-ddi-poc1"
#     location            = "eastus"
#     tags = {
#       env = "poc"
#     location = "eastus" },
#     web_application_firewall_name = null // name is required when WAf is enabled.

#     sku = {
#       name     = "WAF_v2" // possible values : Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2 //
#       tier     = "WAF_v2" // possible values : Standard, Standard_v2, WAF and WAF_v2 //
#       capacity = 0
#     }

#     autoscale_configuration = {
#       min_capacity = "1"
#       max_capacity = "3"
#     }

#     enable_http2 = "false"
#     zones        = ["1", "2"]

#     gateway_ip_configuration = {
#       name        = "gateway-ip-config"
#       subnet_name = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-appgw")
#     }

#     frontend_ip_configuration = [
#       {
#         name                            = "frnt-public-ip-ddi"
#         subnet_name                     = null
#         private_ip_address              = null
#         public_ip_name                  = "publicip-ddi-appgw"
#         private_ip_address_allocation   = null
#         private_link_configuration_name = null
#       },
#       {
#         name                            = "frnt-private-ip-ddi"
#         subnet_name                     = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-appgw")
#         private_ip_address              = "10.100.3.5"
#         public_ip_name                  = null
#         private_ip_address_allocation   = "Static" // always be static
#         private_link_configuration_name = "pvt-link-appgw"
#       }
#     ]

#     backend_address_pool = [
#       {
#         name         = "bkp-ddi-app-fqdn"
#         fqdns        = ["app-ddi-dev.cloudservice.microsoft.net", "app-ddi-dev2.cloudservice.microsoft.net"]
#         ip_addresses = null
#       },
#       {
#         name         = "bkp-ddi-app-vm"
#         fqdns        = null
#         ip_addresses = ["10.100.0.5", "10.100.0.6"]
#       }
#     ]

#     backend_http_settings = [
#       {
#         name                                = "bkp-http-ddi-app-fqdn-settings"
#         cookie_based_affinity               = "Enabled" // possible ["Enabled" "Disabled"]
#         affinity_cookie_name                = "affinity cookie"
#         path                                = "/"
#         port                                = "80"
#         probe_name                          = "probe-app-fqdn-http"
#         protocol                            = "Http" //Http or Https
#         request_timeout                     = "30"
#         host_name                           = "app-ddi-dev.com"
#         pick_host_name_from_backend_address = null // true or false
#         trusted_root_certificate_names      = null
#         connection_draining = {
#           enabled           = false // true or false
#           drain_timeout_sec = "3"   // possible range (1 - 3600)
#         }
#       },
#       {
#         name                                = "bkp-http-ddi-app-vm-settings"
#         cookie_based_affinity               = "Enabled" //possible ["Enabled" "Disabled"]
#         affinity_cookie_name                = "affinity cookie"
#         path                                = "/"
#         port                                = "80"
#         probe_name                          = "probe-app-vm-http"
#         protocol                            = "Http" //Http or Https
#         request_timeout                     = "30"
#         host_name                           = ".*.ddi-qa.com"
#         pick_host_name_from_backend_address = null // true or false
#         trusted_root_certificate_names      = null
#         connection_draining = {
#           enabled           = true
#           drain_timeout_sec = "5" // possible range (1 - 3600)
#         }
#       }
#     ]

#     http_listener = [
#       {
#         name                           = "listener-http-fqdns"
#         frontend_ip_configuration_name = "frnt-public-ip-ddi"
#         port                           = 80
#         host_name                      = "app-ddi-dev.com"
#         host_names                     = null
#         protocol                       = "Http"
#         listener_type                  = " "
#         ssl_certificate_name           = null
#         web_application_firewall_name  = null
#         custom_error_configuration = [
#           # {
#           #  status_code = "HttpStatus502"   //possible ["HttpStatus403" "HttpStatus502"]
#           #  custom_error_page_url  =  "https://ddiworld.com/error.html"
#           # }
#         ]
#       },
#       {
#         name                           = "listener-http-vm"
#         frontend_ip_configuration_name = "frnt-private-ip-ddi"
#         port                           = 8080
#         host_name                      = null
#         host_names                     = [".*.ddi-qa.com"]
#         protocol                       = "Http"
#         listener_type                  = " "
#         ssl_certificate_name           = null
#         web_application_firewall_name  = null
#         custom_error_configuration = [
#           # {
#           #  status_code = "HttpStatus502"  //possible ["HttpStatus403" "HttpStatus502"]
#           #  custom_error_page_url  =  "https://ddiworld.com/error.html"
#           # }
#         ]
#       }

#     ]

#     identity = [
#       {
#         type         = "UserAssigned"
#         identity_ids = [module.useridentity.user_assigned_identity_output["ddi-appgw-identity"].id]
#       }
#     ]


#     private_link_configuration = [
#       {
#         name = "pvt-link-appgw"
#         ip_configuration = [
#           {
#             name                          = "pvt-link-appgw-ip"
#             subnet_name                   = format("%s/%s", "vnet-ddi-poc1", "sub-ddi-poc-appgw")
#             private_ip_address_allocation = "Dynamic"
#             primary                       = true
#             private_ip_address            = null
#           }
#         ]
#       }
#     ]

#     probe = [
#       {
#         name                                      = "probe-app-fqdn-http"
#         host                                      = "app-ddi-dev.com"
#         pick_host_name_from_backend_http_settings = null
#         interval                                  = "20"
#         protocol                                  = "Http"
#         path                                      = "/"
#         timeout                                   = "5"
#         unhealthy_threshold                       = "5"
#         port                                      = "80"
#         match = {
#           body        = null
#           status_code = [200, 399]
#         }
#       },
#       {
#         name                                      = "probe-app-vm-http"
#         host                                      = null #".*.ddi-qa.com"
#         pick_host_name_from_backend_http_settings = true
#         interval                                  = "20"
#         protocol                                  = "Http"
#         path                                      = "/"
#         timeout                                   = "5"
#         unhealthy_threshold                       = "5"
#         port                                      = "80"
#         match = {
#           body        = null
#           status_code = [200, 399]
#         }
#       }
#     ]

#     request_routing_rule = [
#       {
#         name                        = "http-fqdns-request"
#         rule_type                   = "Basic" // Basic or PathBasedRouting
#         http_listener_name          = "listener-http-fqdns"
#         backend_address_pool_name   = "bkp-ddi-app-fqdn"
#         backend_http_settings_name  = "bkp-http-ddi-app-fqdn-settings"
#         redirect_configuration_name = null
#         rewrite_rule_set_name       = null
#         url_path_map_name           = null // empty block when rule_type is basic
#         priority                    = 101
#       },
#       {
#         name                        = "http-vm-request"
#         rule_type                   = "Basic" // Basic or PathBasedRouting
#         http_listener_name          = "listener-http-vm"
#         backend_address_pool_name   = "bkp-ddi-app-vm"
#         backend_http_settings_name  = "bkp-http-ddi-app-vm-settings"
#         redirect_configuration_name = null
#         rewrite_rule_set_name       = null
#         url_path_map_name           = null // empty block when rule_type is basic
#         priority                    = 102
#       }
#     ]

#     global = {
#       request_buffering_enabled  = true
#       response_buffering_enabled = true
#     }

#     ssl_certificate = [
#       #   {
#       #     name =
#       #     Key_vault_name =
#       #     secret_name =
#       # }
#     ]

#     url_path_map = [
#       {
#         name                                = "path-based-url"
#         default_backend_address_pool_name   = "bkp-ddi-app-vm"
#         default_backend_http_settings_name  = "bkp-http-ddi-app-vm-settings"
#         default_redirect_configuration_name = null
#         default_rewrite_rule_set_name       = null
#         path_rule = [
#           {
#             name                          = "path-based-url-test"
#             paths                         = ["/test"]
#             backend_address_pool_name     = "bkp-ddi-app-vm"
#             backend_http_settings_name    = "bkp-http-ddi-app-vm-settings"
#             redirect_configuration_name   = null
#             rewrite_rule_set_name         = null
#             web_application_firewall_name = null
#           }
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
#         enabled                  = true
#         firewall_mode            = "Detection" #Detection and Prevention
#         rule_set_type            = "OWASP"     #OWASP and Microsoft_BotManagerRuleSet
#         rule_set_version         = "3.2"       #0.1, 1.0, 2.2.9, 3.0, 3.1 and 3.
#         file_upload_limit_mb     = "60"        #1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB
#         request_body_check       = true        #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#request_body_check
#         max_request_body_size_kb = 128         #1KB to 128KB

#         disabled_rule_group = [
#           { rule_group_name = "REQUEST-944-APPLICATION-ATTACK-JAVA" #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#rule_group_name
#             rules           = []                                    # list name of rules to disbale. to disable all rules in a group paas empty list
#           }
#         ]

#         exclusion = [
#           {
#             match_variable          = "RequestHeaderNames" #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#match_variable
#             selector_match_operator = "Equals"             #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#selector_match_operator
#             selector                = "testhost"           #null if you want to exclude for all match variable 
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
#         rewrite_rule = [
#           {
#             name          = "client_port_80_rule"
#             rule_sequence = 1
#             condition = [
#               {
#                 variable    = "var_host" #https://learn.microsoft.com/en-us/azure/application-gateway/rewrite-http-headers-url#server-variables
#                 pattern     = "sampleddi.com"
#                 ignore_case = true  //true false
#                 negate      = false //true false
#               }
#             ]

#             request_header_configuration = [
#               {
#                 header_name  = "X-isThroughProxy"
#                 header_value = "True"
#               }
#             ]

#             response_header_configuration = [
#               {
#                 header_name  = "Strict-Transport-Security"
#                 header_value = "max-age=31536000"
#               }
#             ]

#             url = [
#               {
#                 path         = "/artical.aspx"
#                 query_string = ".*article/(.*)/(.*)" #One or both of path and query_string must be specified. If one of these is not specified, it means the value will be empty. If you only want to rewrite path or query_string, use components
#                 components   = null                  #path_only and query_string_only
#                 reroute      = false                 #Used to determine whether the URL path map is to be reevaluated or not. If not set, the original URL path will be used to match the path-pattern in the URL path map. If set, the URL path map will be reevaluated to check the match with the rewritten path.
#               }
#             ]

#           }
#         ]
#       }
#     ]

#   }
# ]

storage_account_list = [
  {
    name                      = "ddistorageacctwo"
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
    name                      = "ddistorageacc1"
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
  },
  {
    name                      = "stgsqlddi"
    resource_group_name       = "rg-ddi-poc1"
    location                  = "eastus"
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

# pass_sql_server_list = [
# {
#   name                            = "ddi-poc-sql-server"
#   resource_group_name             = "rg-ddi-poc1"
#   version                         = "12.0"
#   administrator_login_name        = "sqladmin"
#   administrator_login_password    = "Qwest@72hrNight"
#   minimum_tls_version             = "1.2"     // valid values: 1.0, 1.1 , 1.2 and Disabled. Defaults to 1.2
#   public_network_access_enabled   = true
#   key_vault_name                  = "testiefngkvrss2"
#   azuread_administrator = [
#     {
#       azuread_authentication_only = false
#       login_username              = "ddi-appgw-identity"
#     }
#   ]
# }
# ]

local_network_gateway_list = [
{
    name                = "myoffice"
    resource_group_name = "rg-ddi-poc1"
    gateway_address     = null   // Both gateway_address and gateway_fqdn can be given as input either of one should be null.
    gateway_fqdn        = "abc.com"
    address_space       = ["10.0.0.0/16", "192.168.0.0/16"]
    tags                = {
      owner = "Network Team"
      made_through  = "Terraform"
    }
    enable_bgp          = true //true or false
    bgp_settings        = [
      {
          asn                  = "65050"
          bgp_peering_address  = "10.51.255.254"
          peer_weight          = "100"
    }
    ]
}
]

vpn_list = [ 
  {
    name                        = "myCloud"
    resource_group_name         = "rg-ddi-poc1"
    type                        = "Vpn"
    vpn_type                    = "RouteBased"
    active_active               = true
    enable_bgp                  = true
    sku                         = "VpnGw2AZ"
    generation                  = "Generation2"
    edge_zone                   = null
    private_ip_address_enabled  = true
    tags                        = {owner = "Motifworks"}
    bgp_settings                = [
      {
        asn    = "65050"
        peer_weight = "100"
        peering_addresses = [
          {
            ip_configuration_name  = "myCloud-ip"
            apipa_addresses        = ["169.254.21.0","169.254.21.2" ]
          },
          {
            ip_configuration_name  = "myCloud-ip1"
            apipa_addresses        = ["169.254.22.0","169.254.22.2" ]
          }
        ]
      }
    ]

    ip_configuration    = [
      {
        name                            = "myCloud-ip"
        private_ip_address_allocation   = "Dynamic"
        virtual_network_name            = "vnet-ddi-poc1"
        subnet_name                     = "GatewaySubnet"
        public_ip_name                  = "public-ip-ddi-vpn"
    },
    {
        name                            = "myCloud-ip1"
        private_ip_address_allocation   = "Dynamic"
        virtual_network_name            = "vnet-ddi-poc1"
        subnet_name                     = "GatewaySubnet"
        public_ip_name                  = "public-ip-ddi-vpn1"
    }    
    ]
  }
 ]

 vpn_connection_list   = [
  {
    name                          = "myvpn-connection"
    resource_group_name           = "rg-ddi-poc1"
    type                          = "IPsec"
    vpn_gateway_name              = "myCloud"
    local_network_gateway_name    = "myoffice"
    shared_key                    = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
    connection_protocol           = "IKEv2"
    connection_mode               = "Default"
    dpd_timeout_seconds           = "45"
    enable_bgp                    = false
    custom_bgp_addresses          = [{
      primary       = "169.254.21.0"
      secondary     = "169.254.22.0"
    }]
    tags                          = {owner = "motifworks"}
  }
 ]