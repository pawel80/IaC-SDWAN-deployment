variable "admin_account" {
  description = "Local admin account"
  type        = string
  default     = ""
}

variable "admin_account_pass" {
  description = "Local admin account password"
  type        = string
  default     = ""
}

variable "var_vpn511_gig2_511_if_address" {
  description = "Legacy core mgmt address"
  type = string
  default = "172.16.51.1 255.255.255.252"
}