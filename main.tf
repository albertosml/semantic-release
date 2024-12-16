terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

resource "azurerm_resource_group" "example_app" {
  name     = "my-example-app"
  location = "West Europe"
}

resource "azurerm_service_plan" "example_app" {
  name                = "my-example-app-service"
  resource_group_name = azurerm_resource_group.example_app.name
  location            = azurerm_resource_group.example_app.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "example_app" {
  name                = "example"
  resource_group_name = azurerm_resource_group.example_app.name
  location            = azurerm_service_plan.example_app.location
  service_plan_id     = azurerm_service_plan.example_app.id

  site_config {}
}

data "local_file" "dockercompose" {
  filename = "docker-compose.yml"
}

resource "azapi_update_resource" "update_linux_web_app" {
  resource_id = azurerm_linux_web_app.example_app.id
  type        = "Microsoft.Web/sites@2022-03-01"
  body = jsonencode({
    properties = {
      siteConfig = {
        linuxFxVersion             = "COMPOSE|${data.local_file.dockercompose.content_base64}"
        acrUseManagedIdentityCreds = true
      }
    }
  })
}