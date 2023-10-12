terraform {
   #required_version = ">= 1.5.7"//0.13.3
  required_providers {
    azurerm = {
      version = ">=3.75.0"
    }
  }

}

provider "azurerm" {
  features {  
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    }
  skip_provider_registration = true
 
}