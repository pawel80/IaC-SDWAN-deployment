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
    },
    {
      name = "ROUTER8"
      url  = "https://172.16.10.38"
      hostname = "S8R1"
      ip_address = "172.16.10.38"
      mask = "255.255.255.252"
    }
  ]
}

provider "iosxe" {
  username = var.LEGACY_USERNAME
  password = var.LEGACY_PASSWORD
  devices  = local.legacy_routers
}
