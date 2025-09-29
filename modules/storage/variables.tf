variable "name_prefix" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_id" { type = string }
variable "subnet_id" { type = string }
variable "vnet_links" { type = map(string) }