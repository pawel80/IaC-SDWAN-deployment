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

resource "iosxe_interface_ethernet" "core_gig2" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2"
  description                    = "SERVICES"
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig2_502" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.502"
  encapsulation_dot1q_vlan_id    = 502
  ipv4_address                   = each.value.gig2_502_ip_address
  ipv4_address_mask              = each.value.gig2_502_mask
  description                    = each.value.gig2_502_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig2_200" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.200"
  encapsulation_dot1q_vlan_id    = 200
  ipv4_address                   = each.value.gig2_200_ip_address
  ipv4_address_mask              = each.value.gig2_200_mask
  description                    = each.value.gig2_200_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig2_503" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.503"
  encapsulation_dot1q_vlan_id    = 503
  ipv4_address                   = each.value.gig2_503_ip_address
  ipv4_address_mask              = each.value.gig2_503_mask
  description                    = each.value.gig2_503_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig2_300" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.300"
  encapsulation_dot1q_vlan_id    = 300
  ipv4_address                   = each.value.gig2_300_ip_address
  ipv4_address_mask              = each.value.gig2_300_mask
  description                    = each.value.gig2_300_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig2_504" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.504"
  encapsulation_dot1q_vlan_id    = 504
  ipv4_address                   = each.value.gig2_504_ip_address
  ipv4_address_mask              = each.value.gig2_504_mask
  description                    = each.value.gig2_504_desc
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

resource "iosxe_interface_ethernet" "core_gig2_506" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.506"
  encapsulation_dot1q_vlan_id    = 506
  ipv4_address                   = each.value.gig2_506_ip_address
  ipv4_address_mask              = each.value.gig2_506_mask
  description                    = each.value.gig2_506_desc
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "core_gig2_600" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "2.600"
  encapsulation_dot1q_vlan_id    = 600
  ipv4_address                   = each.value.gig2_600_ip_address
  ipv4_address_mask              = each.value.gig2_600_mask
  description                    = each.value.gig2_600_desc
  shutdown                       = false
}

resource "iosxe_interface_loopback" "loop_99" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  name                           = 99
  description                    = each.value.loop_99_desc
  ipv4_address                   = each.value.loop_99_ip_address
  ipv4_address_mask              = each.value.loop_99_mask
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
  provider                            = iosxe.cores
  for_each                            = {for router in local.legacy_core_routers : router.name => router}
  device                              = each.value.name
  asn                                 = each.value.bgp_asn
  af_name                             = "unicast"
  ipv4_unicast_redistribute_connected = true
  ipv4_unicast_aggregate_addresses = [
    {
      ipv4_address = "10.0.0.0"
      ipv4_mask    = "255.0.0.0"
    }
  ]
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor1" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb1_ip_address
  remote_as            = each.value.bgp_nb1_asn
  description          = each.value.bgp_nb1_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor2" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb2_ip_address
  remote_as            = each.value.bgp_nb2_asn
  description          = each.value.bgp_nb2_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_502" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_502_ip_address
  remote_as            = each.value.bgp_nb3_502_asn
  description          = each.value.bgp_nb3_502_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_200" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_200_ip_address
  remote_as            = each.value.bgp_nb3_200_asn
  description          = each.value.bgp_nb3_200_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_503" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_503_ip_address
  remote_as            = each.value.bgp_nb3_503_asn
  description          = each.value.bgp_nb3_503_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_300" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_300_ip_address
  remote_as            = each.value.bgp_nb3_300_asn
  description          = each.value.bgp_nb3_300_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_504" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_504_ip_address
  remote_as            = each.value.bgp_nb3_504_asn
  description          = each.value.bgp_nb3_504_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_400" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_400_ip_address
  remote_as            = each.value.bgp_nb3_400_asn
  description          = each.value.bgp_nb3_400_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_506" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_506_ip_address
  remote_as            = each.value.bgp_nb3_506_asn
  description          = each.value.bgp_nb3_506_desc
  shutdown             = false
}

resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_600" {
  provider             = iosxe.cores
  for_each             = {for router in local.legacy_core_routers : router.name => router}
  device               = each.value.name
  asn                  = each.value.bgp_asn
  ip                   = each.value.bgp_nb3_600_ip_address
  remote_as            = each.value.bgp_nb3_600_asn
  description          = each.value.bgp_nb3_600_desc
  shutdown             = false
}

# Route-maps are part of this resource
resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor1_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor1]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb1_ip_address
  activate                    = true
  # route_maps = [
  #   {
  #     in_out         = "in"
  #     route_map_name = "RM-WAN1"
  #   }
  # ]
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor2_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor2]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb2_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_502_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_502]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_502_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_200_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_200]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_200_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_503_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_503]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_503_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_300_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_300]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_300_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_504_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_504]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_504_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_400_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_400]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_400_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_506_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_506]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_506_ip_address
  activate                    = true
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_600_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_600]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_600_ip_address
  activate                    = true
}

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
