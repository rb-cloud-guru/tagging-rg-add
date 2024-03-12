terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.91.0"
    }
  }
}
provider "azurerm" {
    features {}
    subscription_id = "24d682c1-836d-403d-8ee7-1719ffb8bcac"
    client_id = "319ba94f-be24-4664-9320-e020548dd05b"
    client_secret = "D478Q~YDycHxyc7AvKa-~f25Ffk89bjD_x1dXdpI"
    tenant_id = "9bd4fb44-f0c3-42ce-8132-57bf4012a2f0"
}