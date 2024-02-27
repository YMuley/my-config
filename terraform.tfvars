

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
        destination_addresses = ["13.64.185.193"]
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
        destination_addresses = ["13.64.185.193"]
        destination_ports     = ["80"] //only single value is supported ,multiple value or ports will throw error
        protocols             = ["TCP"]
      }
    ]
  }
]
 
