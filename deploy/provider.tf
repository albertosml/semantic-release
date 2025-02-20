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

  backend "azurerm" {
    resource_group_name  = "book-recommender"
    storage_account_name = "bookrecommenderstoacc"
    container_name       = "tfstate"
    key                  = "book-recommender.tfstate"
  }
}

provider "azurerm" {
  features {}
}