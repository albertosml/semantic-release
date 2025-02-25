terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.17.0"
    }
  }
  required_version = ">= 0.13.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-book-recommender"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "bookrecommenderstoacc"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_account_container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}