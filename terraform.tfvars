azure_firewall_list = [
  {
    name                = "fw-ddi-westus"
    resource_group_name = "rg-ddi-dev1"
    location            = "westus"
    sku_name            = "AZFW_VNet"
    sku_tier            = "Standard"
    dns_servers         = ["168.63.129.16"]
    private_ip_ranges   = ["10.0.0.0/8"]
    zones               = []
    threat_intel_mode   = "Alert"

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

azure_firewall_application_rule_collection_list = [
  {
    name                = "firewall-rule-collection-1"
    resource_group_name = "rg-ddi-dev1"
    azure_firewall_name = "fw-ddi-westus"
    priority            = 100
    action              = "Allow"

    rule_list = [
      {
        name             = "rule-1"
        source_addresses = ["192.168.1.0/24"]
        target_fqdns     = ["example.com", "contoso.com"]

        protocol_list = [
          {
            port = 80
            type = "Http"
          },
          {
            port = 443
            type = "Https"
          }
        ]
      }
    ]
  }
]

azure_firewall_nat_rule_collection_list = [
  {
    name                = "nat-rule-collection-1"
    resource_group_name = "rg-ddi-dev1"
    azure_firewall_name = "fw-ddi-westus"
    priority            = 100
    action              = "Dnat"

    rule_list = [
      {
        name                  = "rule-1"
        source_addresses      = ["10.0.0.0/24"]
        destination_addresses = ["10.100.19.4"]
        destination_ports     = ["80"] //only single value is supported ,multiple value or ports will throw error
        translated_address    = "192.168.1.1"
        translated_port       = 443
        protocols             = ["TCP"]
      }
    ]
  }
]

azure_firewall_network_rule_collection_list = [
  {
    name                = "network-rule-collection-1"
    resource_group_name = "rg-ddi-dev1"
    azure_firewall_name = "fw-ddi-westus"
    priority            = 100
    action              = "Deny"

    rule_list = [
      {
        name                  = "rule-1-ddi"
        source_addresses      = ["10.0.0.0/24"]
        destination_addresses = ["13.64.185.194"]
        destination_ports     = ["80"] //only single value is supported ,multiple value or ports will throw error
        protocols             = ["TCP"]
      }
    ]
  }
]

azure_firewall_policy_list = [
  {
    name                              = "fwP-ddi-westus"
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

    intrusion_detection = [ //only premimum
      {
        mode           = "Alert"
        private_ranges = ["192.168.1.0/24", "10.1.1.0/24"]

        signature_overrides = [
          {
            id    = ""      #12-digit number (id) which identifies your signature.
            state = "Alert" #state can be any of Off, Alert or Deny.
          }
        ]

        traffic_bypass = [
          {
            name                  = "bypass-rule-1"
            protocol              = "TCP"
            description           = "Bypass rule description"
            destination_addresses = ["192.168.1.1"]
            destination_ports     = ["8080"]
            source_addresses      = ["10.0.0.1"]
          }
        ]
        private_ranges = []
      }
    ]

    tls_certificate = [
      {
        Key_vault_name        = "testiefngkvrss2"
        key_vault_secret_name = "cert-secret-name-1"
      }
    ]

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
