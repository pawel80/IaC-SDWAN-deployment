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

resource "iosxe_vrf" "edge_vrf_502" {
  for_each            = {for router in local.legacy_routers : router.name => router}
  device              = each.value.name
  name                = "502"
  description         = "Legacy Edge Monitoring(open)"
  rd                  = each.value.edge_rd_vrf_502
  address_family_ipv4 = true
  address_family_ipv6 = false
}

resource "iosxe_vrf" "edge_vrf_200" {
  for_each            = {for router in local.legacy_routers : router.name => router}
  device              = each.value.name
  name                = "200"
  description         = "Legacy Edge Services(open)"
  rd                  = each.value.edge_rd_vrf_200
  address_family_ipv4 = true
  address_family_ipv6 = false
}

resource "iosxe_interface_loopback" "edge_loop_502" {
  for_each            = {for router in local.legacy_routers : router.name => router}
  device              = each.value.name
  name                = 52
  vrf_forwarding      = "200"
  description         = each.value.edge_loop_52_desc
  ipv4_address        = each.value.edge_loop_52_ip_address
  ipv4_address_mask   = each.value.edge_loop_52_mask
  shutdown            = false
}

resource "iosxe_interface_loopback" "edge_loop_200" {
  for_each            = {for router in local.legacy_routers : router.name => router}
  device              = each.value.name
  name                = 20
  vrf_forwarding      = "200"
  description         = each.value.edge_loop_20_desc
  ipv4_address        = each.value.edge_loop_20_ip_address
  ipv4_address_mask   = each.value.edge_loop_20_mask
  shutdown            = false
}

resource "iosxe_interface_tunnel" "edge_GRE1" {
  for_each                = {for router in local.legacy_routers : router.name => router}
  device                  = each.value.name
  name                    = 1
  description             = "GRE towards CORE1"
  shutdown                = false
  ip_proxy_arp            = false
  ip_redirects            = false
  ip_unreachables         = false
  vrf_forwarding          = "200"
  tunnel_source           = each.value.edge_tunnel1_src
  tunnel_destination_ipv4 = each.value.edge_tunnel1_dst
  ipv4_address            = each.value.edge_tunnel1_ip_address
  ipv4_address_mask       = each.value.edge_tunnel1_mask
}

resource "iosxe_interface_tunnel" "edge_GRE2" {
  for_each                = {for router in local.legacy_routers : router.name => router}
  device                  = each.value.name
  name                    = 2
  description             = "GRE towards CORE2"
  shutdown                = false
  ip_proxy_arp            = false
  ip_redirects            = false
  ip_unreachables         = false
  vrf_forwarding          = "200"
  tunnel_source           = each.value.edge_tunnel2_src
  tunnel_destination_ipv4 = each.value.edge_tunnel2_dst
  ipv4_address            = each.value.edge_tunnel2_ip_address
  ipv4_address_mask       = each.value.edge_tunnel2_mask
}

resource "iosxe_interface_tunnel" "edge_GRE3" {
  for_each                = {for router in local.legacy_routers : router.name => router}
  device                  = each.value.name
  name                    = 3
  description             = "GRE towards CORE3"
  shutdown                = false
  ip_proxy_arp            = false
  ip_redirects            = false
  ip_unreachables         = false
  vrf_forwarding          = "200"
  tunnel_source           = each.value.edge_tunnel3_src
  tunnel_destination_ipv4 = each.value.edge_tunnel3_dst
  ipv4_address            = each.value.edge_tunnel3_ip_address
  ipv4_address_mask       = each.value.edge_tunnel3_mask
}

# resource "iosxe_static_route_vrf" "edge_route_leak_for_GRE" {
#   for_each                = {for router in local.legacy_routers : router.name => router}
#   device                  = each.value.name
#   vrf = "200"
#   routes = [
#     {
#       # prefix = each.value.edge_tunnel1_dst
#       prefix = "192.168.201.1"
#       mask   = "255.255.255.255"
#       next_hops = [
#         {
#           next_hop  = "172.16.10.37"
#           metric    = 10
#           global    = true
#           name      = "GigabitEthernet1"
#           permanent = true
#           tag       = 100
#         }
#       ]
#     },
#     {
#       prefix = each.value.edge_tunnel2_dst
#       mask   = "255.255.255.255"
#       next_hops = [
#         {
#           next_hop  = "GigabitEthernet1"
#           metric    = 10
#           global    = true
#           name      = "GRE_needed"
#           permanent = true
#         }
#       ]
#     },
#     {
#       prefix = each.value.edge_tunnel3_dst
#       mask   = "255.255.255.255"
#       next_hops = [
#         {
#           next_hop  = "GigabitEthernet1"
#           metric    = 10
#           global    = true
#           name      = "GRE_needed"
#           permanent = true
#         }
#       ]
#     }
#   ]
# }

resource "iosxe_cli" "global_loop111" {
  for_each                      = {for router in local.legacy_routers : router.name => router}
  device                        = each.value.name
  cli                           = <<-EOT
  ip route vrf 200 192.168.201.1 255.255.255.255 GigabitEthernet1 172.16.10.37 global
  ip route 192.168.28.1 255.255.255.255 Loopback20
  !ip address {{var_lp_502_if_address}} {{var_lp_502_if_mask}}
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

resource "iosxe_vrf" "core_vrf_506" {
  provider            = iosxe.cores
  for_each            = {for router in local.legacy_core_routers : router.name => router}
  device              = each.value.name
  name                = "506"
  description         = "SD-WAN_Monitoring(sec)"
  # vpn_id              = "506"
  rd                  = each.value.rd_vrf_506
  address_family_ipv4 = true
  address_family_ipv6 = false
}

resource "iosxe_vrf" "core_vrf_600" {
  provider            = iosxe.cores
  for_each            = {for router in local.legacy_core_routers : router.name => router}
  device              = each.value.name
  name                = "600"
  description         = "SD-WAN_Services(sec)"
  rd                  = each.value.rd_vrf_600
  address_family_ipv4 = true
  address_family_ipv6 = false
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
  vrf_forwarding                 = "506"
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
  vrf_forwarding                 = "600"
  encapsulation_dot1q_vlan_id    = 600
  ipv4_address                   = each.value.gig2_600_ip_address
  ipv4_address_mask              = each.value.gig2_600_mask
  description                    = each.value.gig2_600_desc
  shutdown                       = false
}

resource "iosxe_interface_loopback" "core_loop_99" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  name                           = 99
  description                    = each.value.loop_99_desc
  ipv4_address                   = each.value.loop_99_ip_address
  ipv4_address_mask              = each.value.loop_99_mask
  shutdown                       = false
}

resource "iosxe_interface_loopback" "core_loop_54" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  name                           = 54
  # vrf_forwarding                 = "504"
  description                    = each.value.loop_54_desc
  ipv4_address                   = each.value.loop_54_ip_address
  ipv4_address_mask              = each.value.loop_54_mask
  shutdown                       = false
}

resource "iosxe_interface_loopback" "core_loop_56" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  name                           = 56
  vrf_forwarding                 = "506"
  description                    = each.value.loop_56_desc
  ipv4_address                   = each.value.loop_56_ip_address
  ipv4_address_mask              = each.value.loop_56_mask
  shutdown                       = false
}

resource "iosxe_interface_loopback" "core_loop_60" {
  provider                       = iosxe.cores
  for_each                       = {for router in local.legacy_core_routers : router.name => router}
  device                         = each.value.name
  name                           = 60
  vrf_forwarding                 = "600"
  description                    = each.value.loop_60_desc
  ipv4_address                   = each.value.loop_60_ip_address
  ipv4_address_mask              = each.value.loop_60_mask
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
  # default_ipv4_unicast = true
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

resource "iosxe_bgp_address_family_ipv4_vrf" "core_bgp_vrf_506_600" {
  provider                                = iosxe.cores
  for_each                                = {for router in local.legacy_core_routers : router.name => router}
  device                                  = each.value.name
  asn                                     = each.value.bgp_asn
  af_name                                 = "unicast"
  vrfs = [
    {
      name                                = "506"
      ipv4_unicast_redistribute_connected = true
      ipv4_unicast_aggregate_addresses = [
        {
          ipv4_address = "10.0.0.0"
          ipv4_mask    = "255.0.0.0"
        }
      ]
    },
    {
      name                                = "600"
      ipv4_unicast_redistribute_connected = true
      ipv4_unicast_aggregate_addresses = [
        {
          ipv4_address = "10.0.0.0"
          ipv4_mask    = "255.0.0.0"
        }
      ]
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

# resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_506" {
#   provider             = iosxe.cores
#   for_each             = {for router in local.legacy_core_routers : router.name => router}
#   device               = each.value.name
#   asn                  = each.value.bgp_asn
#   ip                   = each.value.bgp_nb3_506_ip_address
#   remote_as            = each.value.bgp_nb3_506_asn
#   description          = each.value.bgp_nb3_506_desc
#   shutdown             = false
# }

# resource "iosxe_bgp_neighbor" "core_bgp_neighbor3_600" {
#   provider             = iosxe.cores
#   for_each             = {for router in local.legacy_core_routers : router.name => router}
#   device               = each.value.name
#   asn                  = each.value.bgp_asn
#   ip                   = each.value.bgp_nb3_600_ip_address
#   remote_as            = each.value.bgp_nb3_600_asn
#   description          = each.value.bgp_nb3_600_desc
#   shutdown             = false
# }

# Route-maps are part of this resource
resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor1_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor1]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb1_ip_address
  activate                    = true
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
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_200_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_200]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_200_ip_address
  activate                    = true
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_503_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_503]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_503_ip_address
  activate                    = true
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_300_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_300]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_300_ip_address
  activate                    = true
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_504_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_504]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_504_ip_address
  activate                    = true
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "core_bgp_neighbor3_400_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  depends_on                  = [iosxe_bgp_neighbor.core_bgp_neighbor3_400]
  asn                         = each.value.bgp_asn
  ip                          = each.value.bgp_nb3_400_ip_address
  activate                    = true
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_bgp_ipv4_unicast_vrf_neighbor" "core_bgp_nb_506_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  asn                         = each.value.bgp_asn
  vrf                         = "506"
  ip                          = each.value.bgp_nb3_506_ip_address
  remote_as                   = each.value.bgp_nb3_506_asn
  description                 = each.value.bgp_nb3_506_desc
  shutdown                    = false
  activate                    = true
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_bgp_ipv4_unicast_vrf_neighbor" "core_bgp_nb_600_af" {
  provider                    = iosxe.cores
  for_each                    = {for router in local.legacy_core_routers : router.name => router}
  device                      = each.value.name
  asn                         = each.value.bgp_asn
  vrf                         = "600"
  ip                          = each.value.bgp_nb3_600_ip_address
  remote_as                   = each.value.bgp_nb3_600_asn
  description                 = each.value.bgp_nb3_600_desc
  shutdown                    = false
  activate                    = true
  route_maps = [
    {
      in_out         = "out"
      route_map_name = "RM-DEFAULT-ROUTE"
    }
  ]
}

resource "iosxe_prefix_list" "core_pl_all_prefixes" {
  provider         = iosxe.cores
  for_each         = {for router in local.legacy_core_routers : router.name => router}
  device           = each.value.name
  prefixes = [
    {
      name   = "PL-ALL-PREFIXES"
      seq    = 10
      action = "permit"
      ip     = "0.0.0.0/0"
      le     = "32"
    }
  ]
}

resource "iosxe_prefix_list" "core_pl_10_0_0_0" {
  provider         = iosxe.cores
  for_each         = {for router in local.legacy_core_routers : router.name => router}
  device           = each.value.name
  prefixes = [
    {
      name   = "PL-DEFAULT-ROUTE"
      seq    = 10
      action = "permit"
      ip     = "10.0.0.0/8"
    }
  ]
}

resource "iosxe_route_map" "core_rm_default_route" {
  provider        = iosxe.cores
  for_each        = {for router in local.legacy_core_routers : router.name => router}
  device          = each.value.name
  name = "RM-DEFAULT-ROUTE"
  entries = [
    {
      seq                                      = 10
      operation                                = "permit"
      description                              = "default-route"
      match_ip_address_prefix_lists            = ["PL-DEFAULT-ROUTE"]
    },
    {
      seq                                      = 99
      operation                                = "deny"
      description                              = "deny-all"
      match_ip_address_prefix_lists            = ["PL-ALL-PREFIXES"]
    }
  ]
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
