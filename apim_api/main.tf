provider "azurerm" {
  features {}
}

data "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_account_blob_container_sas" "this" {
  connection_string = data.azurerm_storage_account.this.primary_connection_string
  container_name    = var.storage_container_name

  // REFACTOR: date.now()
  start = "2022-01-01T00:00:00Z"
  // REFACTOR: date.now() + 1h
  expiry = "2023-01-01T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

data "azurerm_api_management" "this" {
  name                = var.apim_name
  resource_group_name = var.apim_rg
}

resource "azurerm_api_management_api" "this" {
  name                = "${var.fn_name}-api"
  resource_group_name = data.azurerm_api_management.this.resource_group_name
  api_management_name = data.azurerm_api_management.this.name
  revision            = "1"
  display_name        = "Function API"
  path                = "api/v1/sign"
  protocols           = ["https"]

  import {
    content_format = "openapi-link"
    # RAISE error if yaml not exists
    content_value = "https://${azurerm_storage_account.this.name}.blob.core.windows.net/${azurerm_storage_container.this.name}/${var.fn_version}.openapi.yaml${data.azurerm_storage_account_blob_container_sas.this.sas}"
  }
}

resource "azurerm_api_management_named_value" "url" {
  name                = "fn-url"
  api_management_name = data.azurerm_api_management.this.name
  resource_group_name = data.azurerm_api_management.this.resource_group_name
  display_name        = "fn-url"
  value               = "https://${var.fn_name}.azurewebsites.net"
}

resource "azurerm_api_management_api_policy" "this" {
  api_name            = azurerm_api_management_api.this.name
  api_management_name = data.azurerm_api_management.this.name
  resource_group_name = data.azurerm_api_management.this.resource_group_name

  # RAISE error if yaml not exists
  xml_link = "https://${azurerm_storage_account.this.name}.blob.core.windows.net/${azurerm_storage_container.this.name}/${var.fn_version}.policy.xml${data.azurerm_storage_account_blob_container_sas.this.sas}"
}
