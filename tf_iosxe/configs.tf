resource "iosxe_system" "system_all" {
  # Looping through the list of objects
  for_each                    = {for index,router in local.legacy_routers : router.name => router}
  device                      = each.value.name
  hostname                    = each.value.hostname
  # provider                    = iosxe.RT7
  # ip_bgp_community_new_format = true
  # ipv6_unicast_routing        = true
  # ip_source_route             = false
  ip_domain_lookup            = false
  ip_domain_name              = "lab.com"
  # login_delay                 = 10
  # login_on_failure            = true
  # login_on_failure_log        = true
  # login_on_success            = true
  # login_on_success_log        = true
  # multicast_routing_vrfs = [
  #   {
  #     vrf = "VRF1"
  #   }
  # ]
}

resource "iosxe_cli" "global_loop123" {
  for_each                      = {for index,router in local.legacy_routers : router.name => router}
  device                        = each.value.name
  cli                           = <<-EOT
  interface Loopback111
  description CONFIGURE-VIA-RESTCONF-CLI
  EOT
}

# resource "iosxe_save_config" "ROUTER7" {
# }

resource "iosxe_interface_ethernet" "gig1" {
  for_each                       = {for index,router in local.legacy_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "1"
  description                    = "INTRANET_OPEN"
  ipv4_address                   = each.value.ip_address
  ipv4_address_mask              = each.value.mask
  shutdown                       = false
}

# resource "iosxe_interface_ethernet" "gig2" {
#   type                           = "GigabitEthernet"
#   name                           = "2"
#   description                    = "NOT-USED"
#   shutdown                       = true
# }

# resource "iosxe_interface_ethernet" "gig3" {
#   type                           = "GigabitEthernet"
#   name                           = "3"
#   description                    = "NOT-USED"
#   shutdown                       = true
# }

# resource "iosxe_interface_ethernet" "gig4" {
#   type                           = "GigabitEthernet"
#   name                           = "4"
#   description                    = "NOT-USED"
#   shutdown                       = true
# }