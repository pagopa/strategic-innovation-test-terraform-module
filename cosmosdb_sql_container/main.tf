provider "azurerm" {
  features {}
}

resource "azurerm_cosmosdb_sql_container" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name

  account_name       = var.account_name
  database_name      = var.database_name
  partition_key_path = var.partition_key_path
  throughput         = var.throughput
  default_ttl        = var.default_ttl

  dynamic "unique_key" {
    for_each = var.unique_key_paths
    content {
      paths = [unique_key.value]
    }
  }

  dynamic "autoscale_settings" {
    for_each = var.autoscale_settings != null ? [var.autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }

  # this is a temp workaournd until azurerm 3.0 because azurerm 2.99 minimum value is 4000
  lifecycle {
    ignore_changes = [
      autoscale_settings[0].max_throughput,
    ]
  }
}