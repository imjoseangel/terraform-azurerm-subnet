variable "name" {
  description = "Name of Azure Subnet"
  type        = string
}

variable "resource_group" {
  description = "Name of Azure Resource Group for the subnet"
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

variable "enforce_private_link" {
  description = "Enable or disable network policies for private link on the subnet"
  type        = bool
  default     = false
}

variable "network_security_group_name" {
  description = "Name of the network security group to associate with the subnet"
  type        = string
  default     = null
}

variable "nsg_resource_group" {
  description = "Name of the resource group for the network security group"
  type        = string
  default     = null
}

variable "route_table_name" {
  description = "Name of the route table to associate with the subnet"
  type        = string
  default     = null
}

variable "udr_resource_group" {
  description = "Name of the resource group for the route table"
  type        = string
  default     = null
}
