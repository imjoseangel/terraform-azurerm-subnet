data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group
}

data "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = lower(var.name)
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = data.azurerm_virtual_network.main.name
  address_prefixes     = var.address_prefixes

  service_endpoints = var.service_endpoints

  dynamic "delegation" {
    for_each = var.subnet_delegation
    content {
      name = delegation.key
      dynamic "service_delegation" {
        for_each = toset(delegation.value)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }

  enforce_private_link_endpoint_network_policies = var.enforce_private_link
}

data "azurerm_network_security_group" "main" {
  count               = var.network_security_group_name == null ? 0 : 1
  name                = var.network_security_group_name
  resource_group_name = var.nsg_resource_group
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count                     = var.network_security_group_name == null ? 0 : 1
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = data.azurerm_network_security_group.main[count.index].id
}

data "azurerm_route_table" "main" {
  count               = var.route_table_name == null ? 0 : 1
  name                = var.route_table_name
  resource_group_name = var.udr_resource_group
}

resource "azurerm_subnet_route_table_association" "main" {
  count          = var.route_table_name == null ? 0 : 1
  subnet_id      = azurerm_subnet.main.id
  route_table_id = data.azurerm_route_table.main[count.index].id
}
