# terraform-azurerm-subnet

[![Terraform](https://github.com/imjoseangel/terraform-azurerm-subnet/actions/workflows/terraform.yml/badge.svg)](https://github.com/imjoseangel/terraform-azurerm-subnet/actions/workflows/terraform.yml)

## Deploys a subnet on Azure with route table and network security group

This Terraform module deploys a subnet on Azure

### NOTES

* A Vnet needs to be created beforehand

## Usage in Terraform 1.0

```terraform
module "subnet" {
  source                               = "github.com/imjoseangel/terraform-azurerm-subnet"
  name                                 = "mysubnet"
  resource_group_name                  = "rsg-subnet"
}
```

## Authors

Originally created by [imjoseangel](http://github.com/imjoseangel)

## License

[MIT](LICENSE)
