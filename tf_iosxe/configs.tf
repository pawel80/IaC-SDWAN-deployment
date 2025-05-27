###################################################################################
################################### Legacy EDGEs ##################################
###################################################################################

resource "iosxe_system" "system_all" {
  # Looping through the list of objects
  for_each                    = {for index,router in local.legacy_routers : router.name => router}
  device                      = each.value.name
  hostname                    = each.value.hostname
  # provider                    = iosxe.RT7
  ip_domain_lookup            = false
  ip_domain_name              = "lab.com"
}

resource "iosxe_interface_ethernet" "gig1" {
  # for_each                       = {for index,router in local.legacy_routers : router.name => router}
  for_each                       = {for router in local.legacy_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "1"
  description                    = "INTRANET_OPEN"
  ipv4_address                   = each.value.ip_address
  ipv4_address_mask              = each.value.mask
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "gig_2_4" {
  for_each                       = {for v in flatten([for router in local.legacy_routers :
                                      [for interface in router.shut_interfaces : {
                                        "device"      = router.name
                                        "int_name"    = interface
                                      }]
                                    ]) : "${v.device} ${v.int_name}" => v }
  device                         = each.value.device
  type                           = "GigabitEthernet"
  name                           = each.value.int_name
  description                    = "NOT-USED"
  shutdown                       = true
}

# Just to present CLI based config
resource "iosxe_cli" "global_loop123" {
  for_each                      = {for index,router in local.legacy_routers : router.name => router}
  device                        = each.value.name
  cli                           = <<-EOT
  interface Loopback111
  description CONFIGURE_VIA_RESTCONF_CLI
  EOT
}

resource "iosxe_save_config" "save_cfg" {
  for_each                       = {for index,router in local.legacy_routers : router.name => router}
  device                         = each.value.name
}



###################################################################################
################################### Legacy COREs ##################################
###################################################################################

resource "iosxe_system" "core_system_all" {
  # provider                    = iosxe.iosxe_cores
  for_each                    = {for router in local.legacy_routers : router.name => router}
  device                      = each.value.name
  hostname                    = each.value.hostname
  ip_domain_lookup            = false
  ip_domain_name              = "lab.com"
}

# resource "iosxe_interface_ethernet" "core_gig3" {
#   provider                       = iosxe.iosxe_cores
#   for_each                       = {for router in local.legacy_core_routers : router.name => router}
#   device                         = each.value.name
#   type                           = "GigabitEthernet"
#   name                           = "3.500"
#   description                    = "INTRANET_OPEN"
#   encapsulation_dot1q_vlan_id    = 500
#   vrf_forwarding                 = "511"
#   ipv4_address                   = each.value.ip_address
#   ipv4_address_mask              = each.value.mask
#   shutdown                       = false
# }