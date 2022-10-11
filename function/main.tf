provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "this" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_storage_account" "this" {
    name                     = "storageaccountiofunction"
    resource_group_name      = azurerm_resource_group.this.name
    location                 = azurerm_resource_group.this.location
    account_tier             = var.account_tier
    account_replication_type = var.account_replication_type
}
resource "azurerm_storage_queue" "internal_queue" {
    for_each = toset(var.queues)

    name                 = each.key
    storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_storage_container" "internal_container" {

    for_each              = toset(var.storage_containers)
    name                  = each.value
    storage_account_name  = azurerm_storage_account.this.name
    container_access_type = "private"
}

resource "azurerm_storage_container" "internal_container_src" {

    name                  = "sourcecode"
    storage_account_name  = azurerm_storage_account.this.name
    container_access_type = "private"
}

##### FUNCTION APP #####
resource "azurerm_user_assigned_identity" "this" {
    name                = "idp-function-identity"
    resource_group_name = azurerm_resource_group.this.name
    location            = azurerm_resource_group.this.location
}

resource "azurerm_role_assignment" "this" {
    scope                            = "${azurerm_storage_account.this.id}/blobServices/default/containers/${azurerm_storage_container.internal_container_src.name}"
    role_definition_name             = "Storage Blob Data Reader"
    principal_id                     = azurerm_user_assigned_identity.this.principal_id
    skip_service_principal_aad_check = true
}

resource "azurerm_service_plan" "this" {
    name                = "idp-functionapp-service-plan"
    resource_group_name = azurerm_resource_group.this.name
    location            = azurerm_resource_group.this.location
    os_type             = "Linux"
    sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "this" {
    name                          = var.fn_name
    location                      = azurerm_resource_group.this.location
    resource_group_name           = azurerm_resource_group.this.name
    service_plan_id               = azurerm_service_plan.this.id
    storage_account_name          = azurerm_storage_account.this.name
    storage_uses_managed_identity = true

    site_config {
    #api_management_api_id = azurerm_api_management_api.this.id
    application_stack {
        node_version = 16
    }
    }

    app_settings = merge(
    {
        # no error if ZIP not exists
        WEBSITE_RUN_FROM_PACKAGE                     = "https://${azurerm_storage_account.this.name}.blob.core.windows.net/${azurerm_storage_container.internal_container_src.name}/${var.fn_version}.zip"
        FUNCTIONS_WORKER_RUNTIME                     = "node"
        WEBSITE_RUN_FROM_PACKAGE_BLOB_MI_RESOURCE_ID = azurerm_user_assigned_identity.this.id
        AzureWebJobsDisableHomepage                  = "true"
        CosmosDbConnectionString                     = var.cosmos_db_connection_string != "" ? var.cosmos_db_connection_string : ""
    },
    var.app_settings,
    )

    identity {
    type = "UserAssigned"
    identity_ids = [
        azurerm_user_assigned_identity.this.id
    ]
    }
}
