variable "name_prefix" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_id" { type = string }
variable "subnet_id" { type = string }
variable "vnet_links" { type = map(string) }

#terraform destroy functionality:

variable "protect_destroy" {
  description = "Hard-stop against destroy. by default true for prod."
  type        = bool
  default     = true
}

variable "destroy_breakglass" {
  description = "Manual override for temp unlock (particular string in sdefined in the root)."
  type        = string
  default     = ""
}