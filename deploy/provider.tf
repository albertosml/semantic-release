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

  # Resource group, storage account and container must be created before initialization.
  backend "azurerm" {
    resource_group_name  = "book-recommender"
    storage_account_name = "bookrecommenderstoacc"
    container_name       = "tfstate"
    key                  = ""
  }
}

provider "azurerm" {
  features {}
}