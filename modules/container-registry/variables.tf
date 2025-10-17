variable "resource_group_name" {
  description = "Name of an existing resource group. If create_resource_group is true this will be created."
  type        = string
  default     = null
}

variable "acr_name" {
  description = "Name of the ACR instance. Must be globally unique."
  type        = string
  default     = null
}

variable "sku" {
  description = "ACR SKU (Basic | Standard | Premium). Use Premium for geo-replication and advanced features."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of Basic, Standard, Premium"
  }
}

variable "admin_enabled" {
  description = "Enable the admin user on ACR. Default: false (recommended disabled for production)."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether to allow public (internet) access to the registry. If false, registry must be accessed via Private Endpoint or Service Endpoints."
  type        = bool
  default     = true
}

variable "trusted_service_access" {
  description = "Allow trusted Microsoft services to access the registry (useful for some features)."
  type        = bool
  default     = true
}

variable "allowed_ip_ranges" {
  description = "Optional list of public IP CIDRs to allow through the ACR network rule set (if set, public_network_access_enabled should usually be true)."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the ACR resource."
  type        = map(string)
  default     = {}
}

variable "identity_type" {
  description = "Type of managed identity to assign: SystemAssigned or UserAssigned."
  type        = string
  default     = "SystemAssigned"
}

variable "enable_encryption" {
  description = "Whether to enable customer-managed key encryption."
  type        = bool
  default     = false
}

variable "key_vault_key_id" {
  description = "ID of the Key Vault key used for ACR encryption."
  type        = string
  default     = null
}

variable "create_scope_map" {
  description = "Whether to create a scope map for token based access."
  type        = bool
  default     = false
}

variable "azurerm_user_assigned_identities" {
  description = "Whether to create a scope map for token based access."
  type        = list(string)
  default     = []
}
