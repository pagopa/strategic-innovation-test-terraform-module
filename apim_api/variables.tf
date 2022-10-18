variable "fn_name" {
  type        = string
  description = "Function version"
}

variable "fn_version" {
  type        = string
  description = "Function version"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Storage Account"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "storage_container_name" {
  type        = string
  description = "The name of the container in the function storage account"
}

variable "apim_rg" {
  type        = string
  description = "Resource Group of the APIM"
}

variable "apim_name" {
  type        = string
  description = "Name of the APIM"
}
