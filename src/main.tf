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

  network_rules {
    default_action = "Deny"
    ip_rules       = ["23.45.1.0/30"]
  }
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