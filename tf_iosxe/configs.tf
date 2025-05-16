# resource "iosxe_restconf" "ROUTER7" {
#   provider   = iosxe.ROUTER7
#   path       = "openconfig-system:system/config"
#   attributes = {
#     hostname = "RTR7"
#   }
# }

# resource "iosxe_restconf" "hostname" {
#   for_each   = toset([for router in local.routers : router.name])
#   device     = each.key
#   path       = "openconfig-system:system/config"
#   attributes = {
#     hostname = each.key
#   }
# }

# resource "iosxe_system" "global7" {
#   provider                    = iosxe.RT7
#   hostname                    = "RTR7"
#   # ip_bgp_community_new_format = true
#   # ipv6_unicast_routing        = true
#   # ip_source_route             = false
#   # ip_domain_lookup            = false
#   ip_domain_name              = "lab.com"
#   # login_delay                 = 10
#   # login_on_failure            = true
#   # login_on_failure_log        = true
#   # login_on_success            = true
#   # login_on_success_log        = true
#   # multicast_routing_vrfs = [
#   #   {
#   #     vrf = "VRF1"
#   #   }
#   # ]
# }

# resource "iosxe_system" "global8" {
#   provider                    = iosxe.RT8
#   hostname                    = "S8R1"
#   ip_domain_name              = "lab.com"
# }

# resource "iosxe_cli" "global_loop123" {
#   cli = <<-EOT
#   interface Loopback123
#   description CONFIGURE-VIA-RESTCONF-CLI
#   EOT
# }

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