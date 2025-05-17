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
  for_each    = {for index,router in local.legacy_routers : router.name => router}
  device      = each.value.name
  cli = <<-EOT
  interface Loopback111
  description CONFIGURE-VIA-RESTCONF-CLI
  EOT
}

# resource "iosxe_save_config" "ROUTER7" {
# }

# resource "iosxe_interface_ethernet" "gig1" {
#   provider                       = iosxe.ROUTER7
#   type                           = "GigabitEthernet"
#   name                           = "2"
#   description                    = "INTRANET"
#   ipv4_address                   = "172.16.10.34"
#   ipv4_address_mask              = "255.255.255.252"
#   shutdown                       = false
# }

# resource "iosxe_interface_ethernet" "gig2" {
#   provider                       = iosxe.ROUTER7
#   type                           = "GigabitEthernet"
#   name                           = "2"
#   description                    = "NOT-USED"
#   shutdown                       = true
# }

# resource "iosxe_interface_ethernet" "gig3" {
#   provider                       = iosxe.ROUTER7
#   type                           = "GigabitEthernet"
#   name                           = "3"
#   description                    = "NOT-USED"
#   shutdown                       = true
# }

# resource "iosxe_interface_ethernet" "gig4" {
#   provider                       = iosxe.ROUTER7
#   type                           = "GigabitEthernet"
#   name                           = "3"
#   description                    = "NOT-USED"
#   shutdown                       = true
# }