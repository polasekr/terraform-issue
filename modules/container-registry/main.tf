# Get the RG (either existing or created)
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_container_registry" "this" {
  name                          = var.acr_name
  resource_group_name           = data.azurerm_resource_group.this.name
  location                      = data.azurerm_resource_group.this.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled

  network_rule_set {
    default_action = length(var.allowed_ip_ranges) > 0 ? "Deny" : "Allow"
  
    dynamic "ip_rule" {
      for_each = toset(var.allowed_ip_ranges)
      content {
        action   = "Allow"
        ip_range = ip_rule.value
      }
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" ? var.azurerm_user_assigned_identities : null
  }

  # Encryption can be only set for UserAssigned identity while using terraform
  # System managed identity created as the part of container registry cannot be referrenced in the same block
  dynamic "encryption" {
    for_each = var.enable_encryption && var.identity_type == "UserAssigned" ? [1] : []
    content {
      key_vault_key_id   = var.key_vault_key_id
      identity_client_id = var.identity_type == "UserAssigned" ? var.azurerm_user_assigned_identities[0] : null
    }
  }

  tags = var.tags
}

# Create ACR Token and scope map (recommended over admin user)
resource "azurerm_container_registry_scope_map" "push_pull" {
  count                   = var.create_scope_map ? 1 : 0
  name                    = "${var.acr_name}-pushpull"
  container_registry_name = azurerm_container_registry.this.name
  resource_group_name     = data.azurerm_resource_group.this.name

  actions = [
    "repositories/*/content/read",
    "repositories/*/content/write",
    "repositories/*/metadata/read",
    "repositories/*/metadata/write"
  ]
}

