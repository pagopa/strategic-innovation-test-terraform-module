output "connection_strings" {
    value     = nonsensitive(azurerm_cosmosdb_account.this.connection_strings[0])
}
