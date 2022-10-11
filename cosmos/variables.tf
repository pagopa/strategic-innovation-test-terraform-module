
variable "location" {
    type        = string
    description = "Location"
    default     = "West Europe"
}

variable "database_name" {
    type        = string
    description = "The name of the Cosmos DB instance."
}

variable "resource_group_name" {
    type        = string
    description = "The name of the resource group in which the Cosmos DB SQL"
}

variable "cosmosdb_account_name" {
    type = string
}

variable "containers_name" {
    type        = list(any)
    description = "List of containers that you want to create"
    default     = []
}

variable "partition_key_path" {
    type        = string
    description = "Define a partition key."
}

variable "throughput" {
    type        = number
    description = "The throughput of SQL container (RU/s). Must be set in increments of 100. The minimum value is 400."
    default     = 400
}

variable "default_ttl" {
    type        = number
    description = "The default time to live of SQL container. If missing, items are not expired automatically."
    default     = null
}

variable "unique_key_paths" {
    type        = list(string)
    description = "A list of paths to use for this unique key."
    default     = []
}

variable "autoscale_settings" {
    type = object({
    max_throughput = number
    })
    default = null
}

variable "subnet_id" {
    type        = string
    description = "Used only for private endpoints"
    default     = null
}

variable "private_dns_zone_ids" {
    type        = list(string)
    description = "Used only for private endpoints"
    default     = []
}

variable "enable_free_tier" {
    type    = bool
    default = true
}

variable "enable_automatic_failover" {
    type    = bool
    default = true
}

variable "offer_type" {
    type        = string
    description = "The CosmosDB account offer type. At the moment can only be set to Standard"
    default     = "Standard"
}

variable "kind" {
    type        = string
    default = "MongoDB"
    description = "Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB and MongoDB."
}

variable "mongo_server_version" {
    type        = string
    description = "The Server Version of a MongoDB account. Possible values are 4.0, 3.6, and 3.2."
    default     = null
}

variable "private_endpoint_enabled" {
    type        = bool
    description = "Enable private endpoint"
    default     = true
}

variable "private_endpoint_name" {
    type        = string
    description = "Private endpoint name. If null it will assume the cosmosdb account name."
    default     = null
}

variable "public_network_access_enabled" {
    type        = bool
    description = "Whether or not public network access is allowed for this CosmosDB account"
    default     = false
}

variable "is_virtual_network_filter_enabled" {
    type        = bool
    description = "Enables virtual network filtering for this Cosmos DB account."
    default     = true
}

variable "key_vault_key_id" {
    type        = string
    description = "(Optional) A versionless Key Vault Key ID for CMK encryption. Changing this forces a new resource to be created. When referencing an azurerm_key_vault_key resource, use versionless_id instead of id"
    default     = null
}

variable "allowed_virtual_network_subnet_ids" {
    type        = list(string)
    description = "The subnets id that are allowed to access this CosmosDB account."
    default     = []
}

variable "consistency_policy" {
    type = object({
    consistency_level       = string
    max_interval_in_seconds = number
    max_staleness_prefix    = number
    })

    default = {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
    }
}

variable "main_geo_location_location" {
    type = string
    default = "westeurope"
}

variable "main_geo_location_zone_redundant" {
    type        = bool
    description = "Should zone redundancy be enabled for main region? Set true for prod environments"
    default     = false
}

variable "additional_geo_locations" {
    type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = bool
    }))
    default = []
}

variable "enable_multiple_write_locations" {
    type        = bool
    description = "Enable multi-master support for this Cosmos DB account."
    default     = false
}

variable "ip_range" {
    type        = string
    description = "The set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account."
    default     = null
}

variable "capabilities" {
    type        = list(string)
    description = "The capabilities which should be enabled for this Cosmos DB account."
    default     = []
}

variable "backup_continuous_enabled" {
    type        = bool
    description = "Enable Continuous Backup"
    default     = true
}

variable "backup_periodic_enabled" {
    type = object({
    interval_in_minutes = string
    retention_in_hours  = string
    storage_redundancy  = string
    })
    description = "Enable Periodic Backup"
    default     = null
}

variable "lock_enable" {
    type        = bool
    default     = false
    description = "Apply lock to block accedentaly deletions."
}

variable "tags" {
    type = map(any)
    default = {}
}
