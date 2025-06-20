terraform {
  required_providers {
    iosxe = {
      # The source needs to be provided since this isn't one of the "official" HashiCorp providers
      source = "CiscoDevNet/iosxe"
      # configuration_aliases = [ iosxe.RT7, iosxe.RT8 ]
      configuration_aliases = [ iosxe.RTDC1R2 ]
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
      name            = "ROUTER7"
      url             = "https://172.16.10.34"
      hostname        = "S7R1"
      # mgmt_int        = "1"
      shut_interfaces = ["2", "3", "4"]
      # ip_address      = "172.16.10.34"
      # mask            = "255.255.255.252"
    },
    {
      name            = "ROUTER8"
      url             = "https://172.16.10.38"
      hostname        = "S8R1"
      # mgmt_int        = "1"
      shut_interfaces = ["2", "3", "4"]
      # ip_address      = "172.16.10.38"
      # mask            = "255.255.255.252"
    }
    # {
    #   name            = "RTDC1R2"
    #   url             = "https://172.16.51.2"
    #   hostname        = "DC1R2"
    #   # mgmt_int        = "2"
    #   shut_interfaces = ["4"]
    #   # ip_address      = "172.16.51.2"
    #   # mask            = "255.255.255.252"
    # }
  ]

  # ADD SECOND LIST
  
  # legacy_core_routers = [
  #   {
  #     name = "ROUTER_DC1R2"
  #     url  = "https://172.16.51.2"
  #     hostname = "DC1R2"
  #     # ip_address = "172.16.51.2"
  #     ip_address = "172.16.50.2"
  #     mask = "255.255.255.252"
  #     shut_interfaces = ["4"]
  #   }
  # ]
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

# TURN THIS PART INTO LIST

provider "iosxe" {
  alias    = "RTDC1R2"
  username = var.LEGACY_USERNAME
  password = var.LEGACY_PASSWORD
  url  = "https://172.16.51.2"
}

# provider "iosxe" {
#   alias    = "iosxe_cores"
#   username = var.LEGACY_USERNAME
#   password = var.LEGACY_PASSWORD
#   devices  = local.legacy_core_routers
# }
