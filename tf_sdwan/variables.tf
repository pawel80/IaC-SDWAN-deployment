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

variable "S1R1_id" {
  description = "SDWAN S1R1 router ID"
  type        = string
  default     = ""
}

variable "S2R1_id" {
  description = "SDWAN S2R1 router ID"
  type        = string
  default     = ""
}

variable "DC1R1_id" {
  description = "SDWAN DC1R1 router ID"
  type        = string
  default     = ""
}

variable "DC2R1_id" {
  description = "SDWAN DC2R1 router ID"
  type        = string
  default     = ""
}

variable "DC3R1_id" {
  description = "SDWAN DC3R1 router ID"
  type        = string
  default     = ""
}

# variable "var_vpn511_gig2_511_if_address" {
#   description = "Legacy core mgmt address"
#   type = string
#   default = "172.16.51.1 255.255.255.252"
# }