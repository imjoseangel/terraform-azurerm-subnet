output "subnet_id" {
  description = "Id of the created subnet"
  value       = azurerm_subnet.main.id
}

output "subnet_cidr_list" {
  description = "CIDR list of the created subnets"
  value       = azurerm_subnet.main.address_prefixes
}

output "subnet_cidrs_map" {
  description = "Map with names and CIDRs of the created subnets"
  value = {
    (azurerm_subnet.main.name) = azurerm_subnet.main.address_prefixes
  }
}

output "subnet_names" {
  description = "Names of the created subnet"
  value       = azurerm_subnet.main.name
}

output "subnet_ips" {
  description = "The collection of IPs within this subnet"
  value       = var.address_prefixes[*]
}
