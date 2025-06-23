###################################################################################
################################### Legacy EDGEs ##################################
###################################################################################

resource "iosxe_system" "system_all" {
  # Looping through the list of objects
# for_each                       = {for index,router in local.legacy_routers : router.name => router}
  for_each                    = {for router in local.legacy_routers : router.name => router}
  device                      = each.value.name
  hostname                    = each.value.hostname
  # provider                    = iosxe.RT7
  ip_domain_lookup            = false
  ip_domain_name              = "lab.com"
}

# resource "iosxe_interface_ethernet" "int_mgmt" {
#   for_each                       = {for router in local.legacy_routers : router.name => router}
#   device                         = each.value.name
#   type                           = "GigabitEthernet"
#   name                           = each.value.mgmt_int
#   description                    = "INTRANET_OPEN"
#   ipv4_address                   = each.value.ip_address
#   ipv4_address_mask              = each.value.mask
#   shutdown                       = false
# }

resource "iosxe_interface_ethernet" "int_shutdown" {
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
  for_each                      = {for router in local.legacy_routers : router.name => router}
  device                        = each.value.name
  cli                           = <<-EOT
  interface Loopback111
  description CONFIGURE_VIA_RESTCONF_CLI
  EOT
}

resource "iosxe_save_config" "save_cfg" {
  for_each                       = {for router in local.legacy_routers : router.name => router}
  device                         = each.value.name
}



###################################################################################
################################### Legacy COREs ##################################
###################################################################################

resource "iosxe_system" "core_system_all" {
  # provider                    = iosxe.RTDC1R2
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  hostname                    = each.value.hostname
  ip_domain_lookup            = false
  ip_domain_name              = "lab.com"
}

resource "iosxe_interface_ethernet" "core_gig1" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "1"
  ipv4_address                   = each.value.gig1_ip_address
  ipv4_address_mask              = each.value.gig1_mask
  description                    = each.value.gig1_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig2_400" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.400"
  encapsulation_dot1q_vlan_id    = 400
  ipv4_address                   = each.value.gig2_400_ip_address
  ipv4_address_mask              = each.value.gig2_400_mask
  description                    = each.value.gig2_400_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig3" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "3"
  ipv4_address                   = each.value.gig3_ip_address
  ipv4_address_mask              = each.value.gig3_mask
  description                    = each.value.gig3_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_int_shutdown" {
  provider                    = iosxe.cores
  for_each                       = {for v in flatten([for router in local.legacy_core_routers :
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

resource "iosxe_bgp" "core_bgp" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  default_ipv4_unicast = true
  log_neighbor_changes = true
  # router_id_loopback   = 100
}

resource "iosxe_bgp_address_family_ipv4" "core_bgp_unicast" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  af_name              = "unicast"
}

# resource "iosxe_bgp_neighbor" "core_bgp_neighbor1" {
#   provider             = iosxe.cores
#   for_each             = {for router in local.legacy_core_routers : router.name => router}
#   device               = each.value.name
#   asn                  = each.value.bgp_asn
#   ip                   = each.value.bgp_nb1_ip_address
#   remote_as            = each.value.bgp_nb1_asn
#   description          = each.value.bgp_nb1_desc
#   shutdown             = false
# }

# resource "iosxe_bgp_neighbor" "core_bgp_neighbor2" {
#   provider             = iosxe.cores
#   for_each             = {for router in local.legacy_core_routers : router.name => router}
#   device               = each.value.name
#   asn                  = each.value.bgp_asn
#   ip                   = each.value.bgp_nb2_ip_address
#   remote_as            = each.value.bgp_nb2_asn
#   description          = each.value.bgp_nb2_desc
#   shutdown             = false
# }

# resource "iosxe_bgp_neighbor" "core_bgp_neighbor3" {
#   provider             = iosxe.cores
#   for_each             = {for router in local.legacy_core_routers : router.name => router}
#   device               = each.value.name
#   asn                  = each.value.bgp_asn
#   ip                   = each.value.bgp_nb3_ip_address
#   remote_as            = each.value.bgp_nb3_asn
#   description          = each.value.bgp_nb3_desc
#   shutdown             = false
# }

# resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor1_af" {
#   provider                    = iosxe.cores
#   for_each                    = {for router in local.legacy_core_routers : router.name => router}
#   device                      = each.value.name
#   depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor1]
#   asn                         = each.value.bgp_asn
#   ip                          = each.value.bgp_nb1_ip_address
#   activate                    = true
# }

# resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor2_af" {
#   provider                    = iosxe.cores
#   for_each                    = {for router in local.legacy_core_routers : router.name => router}
#   device                      = each.value.name
#   depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor2]
#   asn                         = each.value.bgp_asn
#   ip                          = each.value.bgp_nb2_ip_address
#   activate                    = true
# }

resource "terraform_data" "core_null_data" {}

resource "time_sleep" "core_wait_x_seconds" {
  depends_on      = [terraform_data.core_null_data]
  create_duration = "20s"
}

resource "iosxe_save_config" "core_save_cfg" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  depends_on                     = [time_sleep.core_wait_x_seconds]
}
