terraform {
  required_providers {
    iosxe = {
      # The source needs to be provided since this isn't one of the "official" HashiCorp providers
      source = "CiscoDevNet/iosxe"
      # configuration_aliases = [ iosxe.RT7, iosxe.RT8 ]
    }
  }
  cloud {
    organization = "tf-pawel-org"
    workspaces {
    # Different workspace per provider
      name = "tf-iosxe"
    }
  }
}

# provider "iosxe" {
#   alias    = "RT7"
#   username = var.LEGACY_USERNAME
#   password = var.LEGACY_PASSWORD
#   url      = "https://172.16.10.34"
# }

# provider "iosxe" {
#   alias    = "RT8"
#   username = var.LEGACY_USERNAME
#   password = var.LEGACY_PASSWORD
#   url      = "https://172.16.10.38"
# }

locals {
  legacy_routers = [
    {
      name = "ROUTER7"
      url  = "https://172.16.10.34"
      hostname = "S7R1"
      ip_address = "172.16.10.34"
      mask = "255.255.255.252"
      shut_interfaces = ["2", "3", "4"]
    },
    {
      name = "ROUTER8"
      url  = "https://172.16.10.38"
      hostname = "S8R1"
      ip_address = "172.16.10.38"
      mask = "255.255.255.252"
      shut_interfaces = ["2", "3", "4"]
    }
  ]

  #   flat_object = { for k, v in flatten([for router in local.legacy_routers :
  #     [for interface in try(router.shut_interfaces, []) : {
  #       "device"      = router.name
  #       "name"        = interface
  #       "type"        = "GigabitEthernet"
  #       "description" = "NOT-USED"
  #     }]
  # ]) : "${v.device}_${v.name}_${v.type}_${v.description}" => v }

}

# output "flat_object" {
#   value = local.flat_object
# }

provider "iosxe" {
  username = var.LEGACY_USERNAME
  password = var.LEGACY_PASSWORD
  devices  = local.legacy_routers
}
