# resource "iosxe_interface_ethernet" "gig1" {
#   provider                       = iosxe.ROUTER7
#   type                           = "GigabitEthernet"
#   name                           = "2"
#   description                    = "INTRANET"
#   ipv4_address                   = "172.16.10.34"
#   ipv4_address_mask              = "255.255.255.252"
#   shutdown                       = false
# }

resource "iosxe_restconf" "RTR7" {
  provider   = iosxe.ROUTER7
  path       = "openconfig-system:system/config"
  attributes = {
    hostname = "RTR7"
  }
}

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