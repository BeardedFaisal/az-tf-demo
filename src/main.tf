provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "azurerm_resource_group" "demo" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

resource "azurerm_storage_account" "demo" {
  name                     = "637374939350000000"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "demo" {
  name                = "${var.prefix}-asp"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
} 

resource "azurerm_function_app" "demo" {
  name                        = "${var.prefix}-func-aztfdemoffk"
  resource_group_name         = azurerm_resource_group.demo.name
  location                    = azurerm_resource_group.demo.location
  app_service_plan_id         = azurerm_app_service_plan.demo.id
  storage_account_name        = azurerm_storage_account.demo.name
  storage_account_access_key  = azurerm_storage_account.demo.primary_access_key

  site_config {
    ip_restriction {
      ip_address  = "124.184.114.225/30"
    }
  }
}