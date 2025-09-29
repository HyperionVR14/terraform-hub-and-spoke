variable "location" {
description = "Azure region"
type = string
}

variable "subscription_id" {
description = "Subscription ID"
type = string
}

variable "tenant_id" {
description = "Tennant ID"
type = string
}


variable "name_prefix" {
description = "Short name prefix for resources"
type = string
}


variable "hub_address_space" {
type = list(string)
description = "CIDR for hub VNet"
}


variable "spoke1_address_space" {
type = list(string)
}


variable "spoke2_address_space" {
type = list(string)
}


variable "admin_username" {
type = string
description = "VM admin username"
}

variable "ssh_public_key" { 
type = string 
description = "SSH Key"    
}