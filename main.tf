#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, azurerm_resource_group.rg[*].location, [""]), 0)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#---------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  #ts:skip=AC_AZURE_0389 RSG lock should be skipped for now.
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}

data "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  resource_group_name = var.vnet_resource_group_name
}

resource "azurerm_subnet" "main" {
  name                 = lower(var.name)
  resource_group_name  = local.resource_group_name
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

  private_endpoint_network_policies_enabled = var.enforce_private_link
}

data "azurerm_network_security_group" "main" {
  count               = var.network_security_group_name == null ? 0 : 1
  name                = var.network_security_group_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count                     = var.network_security_group_name == null ? 0 : 1
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = data.azurerm_network_security_group.main[count.index].id
}

data "azurerm_route_table" "main" {
  count               = var.route_table_name == null ? 0 : 1
  name                = var.route_table_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet_route_table_association" "main" {
  count          = var.route_table_name == null ? 0 : 1
  subnet_id      = azurerm_subnet.main.id
  route_table_id = data.azurerm_route_table.main[count.index].id
  lifecycle {
    ignore_changes = [route_table_id]
  }
}
