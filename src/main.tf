terraform {
  backend "azurerm" {
    storage_account_name  = "#{storage-account-name}#"
    container_name        = "#{container-name}#"
    key                   = "terraform.tfstate"
    access_key            = "#{state-storage-access-key}#"
  }
}

provider "azurerm" {
  version = "=2.20.0"
  features {}
}

# Unique ID
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Resource Group
resource "azurerm_resource_group" "demo" {
  name     = var.rgname
  location = var.location

  tags = {
    source = "terraform"
  }
}

# Storage Account
resource "azurerm_storage_account" "demo" {
  name                     = "demotfaz${random_integer.ri.result}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    source = "terraform"
  }
}

# App Service Plan
resource "azurerm_app_service_plan" "demo" {
  name                = "demo-appserviceplan"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

# App Service
resource "azurerm_app_service" "demo" {
  name                = "demo-app-service${random_integer.ri.result}"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  app_service_plan_id = azurerm_app_service_plan.demo.id

  site_config {
    dotnet_framework_version = "v4.0"

    #Ok - so it turned out that for Free/Shared tier this property has to be true else provisioning will fail.
    use_32_bit_worker_process = true 
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

# Service Bus
resource "azurerm_servicebus_namespace" "demo" {
  name                = "tfex-servicebus-namespace${random_integer.ri.result}"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "Basic"

  tags = {
    source = "terraform"
  }
}

# Service Bus Queue
resource "azurerm_servicebus_queue" "demo" {
  name                = "tfex_servicebus_queue"
  resource_group_name = azurerm_resource_group.demo.name
  namespace_name      = azurerm_servicebus_namespace.demo.name
}


# App Service Plan
/*resource "azurerm_app_service_plan" "demo" {
  name                = "${var.prefix}-asp"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = {
    source = "terraform"
  }
} 

# Function App
resource "azurerm_function_app" "demo" {
  name                        = "${var.prefix}-func-demotfaz${random_integer.ri.result}"
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

  identity {
    type = "SystemAssigned"
  }

  tags = {
    source = "terraform"
  }
}*/