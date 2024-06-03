variable "name" {
  description = "Name of Azure Subnet"
  type        = string
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all network resources"
  default     = true
  type        = bool
}

variable "resource_group_name" {
  description = "Name of Azure Resource Group for the subnet"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Name of Azure Resource Group for the vnet"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of Azure Virtual Network for the subnet"
  type        = string
}

variable "address_prefixes" {
  description = "Address prefixes of the subnet"
  type        = list(string)
}

variable "service_endpoints" {
  description = "List of Azure Service Endpoints to associate with the subnet"
  type        = list(string)
  default     = []
}

variable "subnet_delegation" {
  description = <<EOD
  "Configuration of the subnet delegation"
  object({
    name = object({
      name = string,
      actions = list(string)
    })
  })
  EOD
  type        = map(list(any))
  default     = {}
}

variable "private_link_policies" {
  description = "Enable or disable network policies for private link on the subnet"
  type        = bool
  default     = true
}

variable "network_security_group_name" {
  description = "Name of the network security group to associate with the subnet"
  type        = string
  default     = null
}

variable "route_table_name" {
  description = "Name of the route table to associate with the subnet"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
