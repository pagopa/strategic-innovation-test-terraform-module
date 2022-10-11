
variable "app_settings" {
    type    = map(any)
    default = {}
}

variable "storage_account_name" {
    type    = string
    default = null
}

variable "location" {
    type    = string
    default = "West Europe"
}

variable "resource_group_name" {
    type = string
}

variable "account_tier" {
    type        = string
    description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
    default     = "Standard"
}

variable "account_replication_type" {
    type        = string
    description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa"
    default     = "GRS"
}

variable "queues" {
    type        = list(string)
    description = "Queues that you need"
    default     = []
}

variable "storage_containers" {
    type        = list(string)
    description = "Storage containers that you need"
    default     = []
}

variable "fn_name" {
    type        = string
    description = "Function version"
    default     = "idp-function-pagopa-test-test"
}

variable "fn_version" {
    type        = string
    description = "Function version"
    default     = "1"
}

variable "cosmos_db_connection_string" {
    type        = string
    sensitive   = true
    description = "CosmoDB Connection string"
    default     = "null"
}
