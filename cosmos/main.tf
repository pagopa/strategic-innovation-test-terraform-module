provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "this" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_cosmosdb_account" "this" {
    name                      = var.cosmosdb_account_name
    location                  = azurerm_resource_group.this.location
    resource_group_name       = azurerm_resource_group.this.name
    offer_type                = var.offer_type
    kind                      = var.kind
    enable_free_tier          = var.enable_free_tier
    enable_automatic_failover = var.enable_automatic_failover

    mongo_server_version = var.mongo_server_version

    geo_location {
    location          = var.main_geo_location_location
    failover_priority = 0
    zone_redundant    = var.main_geo_location_zone_redundant
    }

    dynamic "geo_location" {
    for_each = var.additional_geo_locations

    content {
        location          = geo_location.value.location
        failover_priority = geo_location.value.failover_priority
        zone_redundant    = geo_location.value.zone_redundant
    }
    }

    consistency_policy {
    consistency_level       = var.consistency_policy.consistency_level
    max_interval_in_seconds = var.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.consistency_policy.max_staleness_prefix
    }

    dynamic "capabilities" {
    for_each = var.capabilities

    content {
        name = capabilities.value
    }
    }

    public_network_access_enabled = var.public_network_access_enabled

    // Virtual network settings
    is_virtual_network_filter_enabled = var.is_virtual_network_filter_enabled

    dynamic "virtual_network_rule" {
    for_each = var.allowed_virtual_network_subnet_ids
    iterator = subnet_id

    content {
        id = subnet_id.value
    }
    }
}

resource "azurerm_cosmosdb_sql_database" "this" {
    name                = var.database_name
    resource_group_name = azurerm_resource_group.this.name
    account_name        = azurerm_cosmosdb_account.this.name
    throughput          = var.throughput
}

resource "azurerm_cosmosdb_sql_container" "this" {

    count = length(var.containers_name)

    name                = var.containers_name[count.index]
    resource_group_name = azurerm_resource_group.this.name

    account_name       = azurerm_cosmosdb_account.this.name
    database_name      = azurerm_cosmosdb_sql_database.this.name
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
}
