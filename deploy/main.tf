# Source: https://learn.microsoft.com/es-es/azure/app-service/provision-resource-terraform
resource "azurerm_resource_group" "rg" {
  name     = "book-recommender"
  location = "West Europe"
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "book-recommender-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "book-recommender-web-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.app_service_plan.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  depends_on          = [azurerm_service_plan.app_service_plan]
  https_only          = true

  site_config {
    always_on = false
  }
}

# Source: https://github.com/hashicorp/terraform-provider-azurerm/issues/25167
resource "azapi_update_resource" "enable_sidecar" {
  resource_id = azurerm_linux_web_app.app.id
  type        = "Microsoft.Web/sites@2024-04-01"
  body = {
    properties = {
      siteConfig = {
        linuxFxVersion = "sitecontainers"
      }
    }
  }
  #lifecycle {
  #  replace_triggered_by = [azurerm_linux_web_app.myapp]
  #}
}

resource "azapi_resource" "web_container" {
  depends_on = [azapi_update_resource.enable_sidecar]
  # https://learn.microsoft.com/en-us/rest/api/appservice/web-apps/create-or-update-site-container?view=rest-appservice-2024-04-01#request-body
  type      = "Microsoft.Web/sites/sitecontainers@2024-04-01"
  parent_id = azurerm_linux_web_app.app.id
  name      = "main"
  body = {
    properties = {
      image      = "index.docker.io/albertosml/book-recommender:latest"
      isMain     = true
      targetPort = "3000"
    }
  }
}

resource "azapi_resource" "solr_container" {
  depends_on = [azapi_update_resource.enable_sidecar]
  type       = "Microsoft.Web/sites/sitecontainers@2024-04-01"
  parent_id  = azurerm_linux_web_app.app.id
  name       = "solr"
  body = {
    properties = {
      image      = "index.docker.io/albertosml/solr-books"
      isMain     = false
      targetPort = "8983"
    }
  }
}