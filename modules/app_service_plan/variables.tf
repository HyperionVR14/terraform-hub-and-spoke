variable "name"                { type = string }
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "sku_name"            { type = string }
variable "zone_balancing_enabled" {
  type    = bool
  default = false
}
variable "tags" {
  type    = map(string)
  default = {}
}
