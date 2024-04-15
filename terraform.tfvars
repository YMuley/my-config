# azure_firewall_list = [
#   {
#     name                = "fw-ddi-westus"
#     resource_group_name = "rg-ddi-dev1"
#     location            = "westus"
#     sku_name            = "AZFW_VNet"
#     sku_tier            = "Standard"
#     dns_servers         = ["168.63.129.16"]
#     private_ip_ranges   = ["10.0.0.0/8"]
#     zones               = []
#     threat_intel_mode   = "Alert"

#     ip_configuration = [
#       {
#         name                 = "ip-config-1"
#         virtual_network_name = "vnet-ddi-dev1"
#         subnet_name          = "AzureFirewallSubnet"
#         public_ip_name       = "public-ip-ddi-fw"

#       }
#     ]

#     tags = {
#       environment = "dev"
#     }
#   }
# ]

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

# azure_firewall_policy_list = [
#   {
#     name                              = "fwP-ddi-westus"
#     resource_group_name               = "rg-ddi-dev1"
#     location                          = "westus"
#     private_ip_ranges                 = ["10.0.0.0/16", "192.168.0.0/16"]
#     auto_learn_private_ranges_enabled = true
#     sku                               = "Premium"
#     threat_intelligence_mode          = "Alert"
#     sql_redirect_allowed              = true

#     dns = [
#       {
#         proxy_enabled = false
#         servers       = []
#       }
#     ]

#     identity = [] //only premimum 


#     insights = [
#       {
#         enabled                              = true
#         default_log_analytics_workspace_name = "la-workspace-1"
#         retention_in_days                    = 30
#         log_analytics_workspace = [
#           {
#             log_analytics_workspace_name = "la-workspace-2"
#             firewall_location            = "West US"
#           },
#           {
#             log_analytics_workspace_name = "la-workspace-3"
#             firewall_location            = "East US"
#           }
#         ]
#       }
#     ]

#     intrusion_detection = [ //only premimum
#       {
#         mode           = "Alert"
#         private_ranges = ["192.168.1.0/24", "10.1.1.0/24"]

#         signature_overrides = [
#           {
#             id    = ""      #12-digit number (id) which identifies your signature.
#             state = "Alert" #state can be any of Off, Alert or Deny.
#           }
#         ]

#         traffic_bypass = [
#           {
#             name                  = "bypass-rule-1"
#             protocol              = "TCP"
#             description           = "Bypass rule description"
#             destination_addresses = ["192.168.1.1"]
#             destination_ports     = ["8080"]
#           }
#         ]
#         private_ranges = []
#       }
#     ]

#     tls_certificate = [
#       {
#         Key_vault_name        = "testiefngkvrss2"
#         secret_name           = "secrauce"
#         key_vault_secret_name = "cert-secret-name-1"
#       }
#     ]

#     # explicit_proxy = [
#     #   {
#     #     enabled         = true
#     #     http_port       = 8080
#     #     https_port      = 8443
#     #     enable_pac_file = true
#     #     pac_file_port   = 8888
#     #     pac_file        = "http://example.com/proxy.pac"
#     #   }
#     # ]

#     threat_intelligence_allowlist = [
#       {
#         fqdns        = ["allowed-domain.com"]
#         ip_addresses = ["10.0.0.1"]
#       }
#     ]

#     tags = {
#       environment = "Production"
#       project     = "FirewallProject"
#     }
#   }
# ]

subnet_nsg_association_list = [
  {
    nsg_name             = "nsg-ddi-poc"
    virtual_network_name = "vnet-ddi-poc1"
    subnet_name          = "sub-ddi-poc-web"
  },
  {
    nsg_name             = "nsg-ddi-poc"
    virtual_network_name = "vnet-ddi-dev1"
    subnet_name          = "sub-ddi-dev-web"
  }
]


subnet_route_table_association_list = [
  {
    route_table_name     = "rt-table1"
    virtual_network_name = "vnet-ddi-poc1"
    subnet_name          = "sub-ddi-poc-web"
  }
]

mssql_vm_list = [
  {
    virtual_machine_name = "sql-server-vm"    // name of windows machine where sql connection agent will be installed
    sql_license_type = "PAYG"                 //AHUB (Azure Hybrid Benefit), DR (Disaster Recovery), and PAYG (Pay-As-You-Go)
    r_services_enabled  = true
    sql_connectivity_port = "1433"
    sql_connectivity_type = "PRIVATE"         //LOCAL, PRIVATE and PUBLIC. Defaults to PRIVATE
    sql_connectivity_update_password = "Ddi@123456789"
    sql_connectivity_update_username = "ddiadmin"
    sql_virtual_machine_group_id = null
    tags                         = {
      environment = "test"
    }
    auto_patching = [
      {
      day_of_week = "Sunday"
      maintenance_window_duration_in_minutes = "60"
      maintenance_window_starting_hour = "2"
    }
    ]

    auto_backup = [
    #   {
    #   encryption_enabled  = false
    #   encryption_password = ""
    #   retention_period_in_days = "30"
    #   storage_blob_endpoint = "stgsqlddi"
    #   storage_account_access_key  = ""
    #   system_databases_backup_enabled = "false"
    #   manual_schedule = [
    #     {
    #     full_backup_frequency  = "Weekly"                                   //Valid values include Daily or Weekly.
    #     full_backup_start_hour = "19"                                   //Valid values are from 0 to 23.
    #     full_backup_window_in_hours = "19"                              //Valid values are between 1 and 23.
    #     log_backup_frequency_in_minutes = "5"                          //Valid values are from 5 to 60.
    #     days_of_week  = "Wednesday"                                            //Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday and Sunday
    #   }
    #   ]
    # }
    ]

    key_vault_credential = [
    #   {
    #   name  = ""
    #   key_vault_url = ""
    #   service_principal_name  = ""
    #   service_principal_secret = ""
    # }
    ]


    sql_instance = [
      {
      adhoc_workloads_optimization_enabled = ""
      collation = "SQL_Latin1_General_CP1_CI_AS"
      instant_file_initialization_enabled = true   // Possible values are true and false. Defaults to false
      lock_pages_in_memory_enabled = false          //Possible values are true and false. Defaults to false
      max_dop = "1000"                              //Possible values are between 0 and 32767. Defaults to 0
      max_server_memory_mb = "8064"                 //Possible values are between 128 and 2147483647 Defaults to 2147483647
      min_server_memory_mb = "4064"                 // Possible values are between 0 and 2147483647 Defaults to 0
    }
    ]

    storage_configuration = [
      {
      disk_type = "NEW"                              //Valid values include NEW, EXTEND, or ADD
      storage_workload_type = "GENERAL"              //Valid values include GENERAL, OLTP, or DW
      
      data_settings = [
        {
        default_file_path = "F:\\data"
        luns = [0]
      }
      ]

      log_settings = [
        {
        default_file_path = "L:\\log"
        luns = [1]
      }
      ]
      system_db_on_data_disk_enabled = "false"             // Possible values are true and false. Defaults to false

      temp_db_settings = [
        {
        default_file_path = "T:\\tempDb"
        luns = [2]
        data_file_count = "8"                               //This value defaults to 8.                      
        data_file_size_mb = "256"                           //This value defaults to 256.
        data_file_growth_in_mb = "512"                      //This value defaults to 512.
        log_file_size_mb = "256"                            //This value defaults to 256.
        log_file_growth_mb = "512"                          //This value defaults to 512.
      }
      ]
    }
    ]

    assessment = [
      {
      enabled = "true"                                       //Defaults to true.
      run_immediately = "false"                              //Defaults to false.
      schedule = [
        {
        weekly_interval = "1"                                //Valid values are between 1 and 6.  #Either one of weekly_interval or monthly_occurrence must be specified.
        monthly_occurrence = "2"                             //Valid values are between 1 and 5.
        day_of_week = "Wednesday"                            //Possible values are Friday, Monday, Saturday, Sunday, Thursday, Tuesday and Wednesday.
        start_time = "19:00"                                 //Must be in the format HH:mm.
      }
      ]
    }
    ]

    wsfc_domain_credential = [
      {
      cluster_bootstrap_account_password = "Dddi@123456789"
      cluster_operator_account_password = "Dddi@123456789"
      sql_service_account_password = "Dddi@123456789"
    }
    ]
  }
]