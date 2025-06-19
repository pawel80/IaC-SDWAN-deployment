terraform {
  required_providers {
    iosxe = {
      # The source needs to be provided since this isn't one of the "official" HashiCorp providers
      source = "CiscoDevNet/iosxe"
      configuration_aliases = [ iosxe.cores ]
      # configuration_aliases = [ iosxe.RT7, iosxe.RT8 ]
      # configuration_aliases = [ iosxe.RTDC1R2 ]
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

# provider "iosxe" {
#   alias    = "RTDC1R2"
#   username = var.LEGACY_USERNAME
#   password = var.LEGACY_PASSWORD
#   url  = "https://172.16.51.2"
# }

locals {
  legacy_routers = [
    {
      name            = "ROUTER7"
      url             = "https://172.16.10.34"
      hostname        = "S7R1"
      # mgmt_int        = "1"
      # ip_address      = "172.16.10.34"
      # mask            = "255.255.255.252"
      shut_interfaces = ["2", "3", "4"]
    },
    {
      name            = "ROUTER8"
      url             = "https://172.16.10.38"
      hostname        = "S8R1"
      # mgmt_int        = "1"
      # ip_address      = "172.16.10.38"
      # mask            = "255.255.255.252"
      shut_interfaces = ["2", "3", "4"]
    }
  ]

  legacy_core_routers = [
    {
      name = "ROUTER_DC1R2"
      url  = "https://172.16.51.2"
      hostname = "DC1R2"
      # gig2_ip_address = "172.16.51.2"
      # gig2_mask = "255.255.255.252"
      shut_interfaces = ["4"]
      gig1_ip_address = "192.168.12.1"
      gig1_mask = "255.255.255.252"
      gig1_desc = "DC1R2-DC2R2"
      gig3_ip_address = "192.168.13.1"
      gig3_mask = "255.255.255.252"
      gig3_desc = "DC1R2-DC3R2"
      bgp_asn = "65102"
      bgp_nb1_desc = "DC2R2"
      bgp_nb1_asn = "65202"
      bgp_nb1_ip_address = "192.168.12.2"
      bgp_nb2_desc = "DC3R2"
      bgp_nb2_asn = "65302"
      bgp_nb2_ip_address = "192.168.13.2"
    },
    {
      name = "ROUTER_DC2R2"
      url  = "https://172.16.51.6"
      hostname = "DC2R2"
      # gig2_ip_address = "172.16.51.6"
      # gig2_mask = "255.255.255.252"
      shut_interfaces = ["4"]
      gig1_ip_address = "192.168.12.2"
      gig1_mask = "255.255.255.252"
      gig1_desc = "DC2R2-DC1R2"
      gig3_ip_address = "192.168.23.1"
      gig3_mask = "255.255.255.252"
      gig3_desc = "DC2R2-DC3R2"
      bgp_asn = "65202"
      bgp_nb1_desc = "DC1R2"
      bgp_nb1_asn = "65102"
      bgp_nb1_ip_address = "192.168.12.1"
      bgp_nb2_desc = "DC3R2"
      bgp_nb2_asn = "65302"
      bgp_nb2_ip_address = "192.168.23.2"
    },
    {
      name = "ROUTER_DC3R2"
      url  = "https://172.16.51.10"
      hostname = "DC3R2"
      # gig2_ip_address = "172.16.51.10"
      # gig2_mask = "255.255.255.252"
      shut_interfaces = ["4"]
      gig1_ip_address = "192.168.23.2"
      gig1_mask = "255.255.255.252"
      gig1_desc = "DC3R2-DC2R2"
      gig3_ip_address = "192.168.13.2"
      gig3_mask = "255.255.255.252"
      gig3_desc = "DC32R2-DC1R2"
      bgp_asn = "65302"
      bgp_nb1_desc = "DC2R2"
      bgp_nb1_asn = "65202"
      bgp_nb1_ip_address = "192.168.23.1"
      bgp_nb2_desc = "DC1R2"
      bgp_nb2_asn = "65102"
      bgp_nb2_ip_address = "192.168.13.1"
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

# Same provider, different device list
provider "iosxe" {
  alias    = "cores"
  username = var.LEGACY_USERNAME
  password = var.LEGACY_PASSWORD
  devices  = local.legacy_core_routers
}
