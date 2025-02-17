terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.17.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "2.2.0"
    }
  }
  required_version = ">= 0.13.0"
}

provider "azurerm" {
  features {}
}