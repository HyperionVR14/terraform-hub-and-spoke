variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "name_prefix"         { type = string }
variable "subnet_id"           { type = string }
variable "admin_username"      { type = string }
variable "ssh_public_key"      { type = string }

#terraform destroy functionality:
#
#variable "protect_destroy" {
#  description = "Hard-stop against destroy. by default true for prod."
#  type        = bool
#  default     = true
#}
#
#variable "destroy_breakglass" {
#  description = "Manual override for temp unlock (particular string in sdefined in the root)."
#  type        = string
#  default     = ""
#}    work in progress here :D 