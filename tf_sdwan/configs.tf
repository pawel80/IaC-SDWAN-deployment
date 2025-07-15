###################################################################################
################################## SD-WAN cEDGEs ##################################
###################################################################################

################################# Feature profiles ################################
resource "sdwan_system_feature_profile" "system_v01" {
  name        = "SYSTEM_v01"
  description = "System settings for all of the sites"
}

resource "sdwan_transport_feature_profile" "transport_v01" {
  name        = "TRANSPORT_v01"
  description = "Transport and Management config"
}

resource "sdwan_service_feature_profile" "edge_service_v01" {
  name        = "EDGE_SERVICES_v01"
  description = "Edge service feature profiles"
}

##################################### Features ####################################
resource "sdwan_system_basic_feature" "system_basic_v01" {
  name               = "SYSTEM_BASIC_v01"
  feature_profile_id = sdwan_system_feature_profile.system_v01.id
}

resource "sdwan_system_aaa_feature" "system_aaa_v01" {
  name               = "SYSTEM_AAA_v01"
  feature_profile_id = sdwan_system_feature_profile.system_v01.id
  server_auth_order  = ["local"]
  users = [{
    name     = var.admin_account
    password = var.admin_account_pass
  }]
}

resource "sdwan_system_omp_feature" "system_omp_v01" {
  name                        = "SYSTEM_OMP_v01"
  feature_profile_id          = sdwan_system_feature_profile.system_v01.id
  advertise_ipv4_bgp          = true
  # advertise_ipv6_bgp          = false
  # advertise_ipv6_ospf         = false
  # advertise_ipv6_connected    = false
  # advertise_ipv6_static       = false
  # advertise_ipv6_eigrp        = false
  # advertise_ipv6_lisp         = false
  # advertise_ipv6_isis         = false
}

# resource "sdwan_system_bfd_feature" "system_bfd_v01" {
#   name               = "SYSTEM_BFD_v01"
#   feature_profile_id = sdwan_system_feature_profile.system_v01.id
# }

resource "sdwan_system_global_feature" "system_global_v01" {
  name               = "SYSTEM_GLOBAL_v01"
  feature_profile_id = sdwan_system_feature_profile.system_v01.id
}

# resource "sdwan_system_logging_feature" "system_logging_v01" {
#   name               = "SYSTEM_LOGGING_v01"
#   feature_profile_id = sdwan_system_feature_profile.system_v01.id
# }

resource "sdwan_transport_wan_vpn_feature" "transport_wan_vpn_v01" {
  name                        = "TRANSPORT_WAN_VPN0_v01"
  feature_profile_id          = sdwan_transport_feature_profile.transport_v01.id
  vpn                         = 0
  primary_dns_address_ipv4    = "8.8.8.8"
  secondary_dns_address_ipv4  = "1.1.1.1"
  ipv4_static_routes = [
    {
      network_address = "0.0.0.0"
      subnet_mask     = "0.0.0.0"
      gateway         = "nextHop"
      next_hops = [
        {
          address_variable        = "{{var_def_gtw}}"
          administrative_distance = 1
        }
      ]
    }
  ]
}

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "transport_wan_vpn_if_eth_v01" {
  name                         = "TRANSPORT_WAN_VPN0_IF_ETH_v01"
  feature_profile_id           = sdwan_transport_feature_profile.transport_v01.id
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.transport_wan_vpn_v01.id
  interface_name               = "GigabitEthernet1"
  shutdown                     = false
  interface_description        = "WAN"
  ipv4_configuration_type      = "static"
  ipv4_address_variable        = "{{var_vpn0_gig1_if_address}}"
  ipv4_subnet_mask_variable    = "{{var_vpn0_gig1_if_mask}}"

  tunnel_interface             = true
  tunnel_interface_color       = "biz-internet"
  tunnel_interface_allow_icmp  = true
  tunnel_interface_allow_dns   = true
  tunnel_interface_allow_ntp   = true
  # tunnel_interface_allow_netconf_variable = "{{var_tunnel_netconf}}"
  tunnel_interface_encapsulations = [
    {
      encapsulation = "gre"
    }
  ]
}

resource "sdwan_service_lan_vpn_feature" "edge_vpn504_v01" {
  name                       = "EDGE_VPN504_v01"
  description                = "EDGE VPN504 SD-WAN Monitoring(open)"
  feature_profile_id         = sdwan_service_feature_profile.edge_service_v01.id
  vpn                        = 504
  config_description         = "EDGE VPN504 SD-WAN Monitoring(open)"
}

resource "sdwan_service_lan_vpn_feature" "edge_vpn400_v01" {
  name                       = "EDGE_VPN400_v01"
  description                = "EDGE VPN400 SD-WAN Services(open)"
  feature_profile_id         = sdwan_service_feature_profile.edge_service_v01.id
  vpn                        = 400
  config_description         = "EDGE VPN400 SD-WAN Services(open)"
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "edge_loop_54_v01" {
  name                       = "EDGE_LOOP54_v01"
  description                = "EDGE LOOPBACK54 Monitoring"
  feature_profile_id         = sdwan_service_feature_profile.edge_service_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.edge_vpn504_v01.id
  shutdown                   = false
  interface_name             = "Loopback54"
  interface_description      = "Monitoring"
  ipv4_address_variable      = "{{var_edge_loop54_address}}"
  ipv4_subnet_mask_variable  = "{{var_edge_loop54_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

# resource "sdwan_service_routing_bgp_feature" "edge_bgp_504_v01" {
#   name                     = "EDGE_BGP_504_v01"
#   description              = "Edge BGP towards legacy core routers"
#   feature_profile_id       = sdwan_service_feature_profile.edge_service_v01.id
#   as_number_variable       = "{{var_edge_bgp_asn}}"
#   ipv4_neighbors = [
#     {
#       address_variable        = "{{var_edge_nb_504_ip_address}}"
#       description_variable    = "{{var_edge_nb_504_desc}}"
#       shutdown                = false
#       remote_as_variable      = "{{var_edge_nb_504_asn}}"
#       address_families = [
#         {
#           family_type            = "ipv4-unicast"
#           max_number_of_prefixes = 2000
#           threshold              = 75
#           policy_type            = "restart"
#           restart_interval       = 30
#         }
#       ]
#     }
#   ]
# }

# resource "sdwan_service_routing_bgp_feature" "edge_bgp_400_v01" {
#   name                     = "EDGE_BGP_400_v01"
#   description              = "Edge BGP towards legacy core routers"
#   feature_profile_id       = sdwan_service_feature_profile.edge_service_v01.id
#   as_number_variable       = "{{var_edge_bgp_asn}}"
#   ipv4_neighbors = [
#     {
#       address_variable        = "{{var_edge_nb_400_ip_address}}"
#       description_variable    = "{{var_edge_nb_400_desc}}"
#       shutdown                = false
#       remote_as_variable      = "{{var_edge_nb_400_asn}}"
#       address_families = [
#         {
#           family_type            = "ipv4-unicast"
#           max_number_of_prefixes = 2000
#           threshold              = 75
#           policy_type            = "restart"
#           restart_interval       = 30
#         }
#       ]
#     }
#   ]
# }

################################ Configuration group ##############################
resource "sdwan_configuration_group" "edge_config_group_v01" {
  name        = "CG_EDGES_v01"
  description = "Configuration group - Edges"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.system_v01.id, 
    sdwan_transport_feature_profile.transport_v01.id,
    sdwan_service_feature_profile.edge_service_v01.id,
  ]
  # devices = local.sd-wan_edges
  feature_versions = [
    sdwan_system_basic_feature.system_basic_v01.version,
    sdwan_system_aaa_feature.system_aaa_v01.version,
    # sdwan_system_bfd_feature.system_bfd_v01.version,
    sdwan_system_global_feature.system_global_v01.version,
    # sdwan_system_logging_feature.system_logging_v01.version,
    sdwan_system_omp_feature.system_omp_v01.version,
    sdwan_transport_wan_vpn_feature.transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.transport_wan_vpn_if_eth_v01.version,
    sdwan_service_lan_vpn_feature.edge_vpn504_v01.version,
    sdwan_service_lan_vpn_feature.edge_vpn400_v01.version,
    # sdwan_service_lan_vpn_interface_ethernet_feature.edge_loop_54_v01.version,
  ]
}



###################################################################################
################################## SD-WAN COREs ###################################
###################################################################################

################################# Feature profiles ################################
resource "sdwan_service_feature_profile" "core_service_v01" {
  name        = "CORE_SERVICES_v01"
  description = "Core service feature profiles"
}

resource "sdwan_cli_feature_profile" "core_cli_v01" {
  name        = "CORE_CLI_FEATURE_PROFILE_v01"
  description = "CORE CLI Feature Profile"
}

##################################### Features ####################################
resource "sdwan_service_lan_vpn_feature" "core_vpn511_v01" {
  name                       = "CORE_VPN511_v01"
  description                = "CORE VPN511 Legacy DC core router mgmt"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 511
  config_description         = "CORE VPN511 - Legacy DC core router mgmt"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn502_v01" {
  name                       = "CORE_VPN502_v01"
  description                = "CORE VPN502 Legacy DC cores Monitoring(open)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 502
  config_description         = "CORE VPN502 Legacy DC cores Monitoring(open)"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn200_v01" {
  name                       = "CORE_VPN200_v01"
  description                = "CORE VPN200 Legacy DC cores Services(open)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 200
  config_description         = "CORE VPN200 Legacy DC cores Services(open)"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn503_v01" {
  name                       = "CORE_VPN503_v01"
  description                = "CORE VPN503 SD-routing Monitoring(open)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 503
  config_description         = "CORE VPN503 SD-routing Monitoring(open)"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn300_v01" {
  name                       = "CORE_VPN300_v01"
  description                = "CORE VPN300 SD-routing Services(open)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 300
  config_description         = "CORE VPN300 SD-routing Services(open)"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn504_v01" {
  name                       = "CORE_VPN504_v01"
  description                = "CORE VPN504 SD-WAN Monitoring(open)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 504
  config_description         = "CORE VPN504 SD-WAN Monitoring(open)"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn400_v01" {
  name                       = "CORE_VPN400_v01"
  description                = "CORE VPN400 SD-WAN Services(open)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 400
  config_description         = "CORE VPN400 SD-WAN Services(open)"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn506_v01" {
  name                       = "CORE_VPN506_v01"
  description                = "CORE VPN506 SD-WAN Monitoring(sec)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 506
  config_description         = "CORE VPN506 SD-WAN Monitoring(sec)"
}

resource "sdwan_service_lan_vpn_feature" "core_vpn600_v01" {
  name                       = "CORE_VPN600_v01"
  description                = "CORE VPN600 SD-WAN Services(sec)"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  vpn                        = 600
  config_description         = "CORE VPN600 SD-WAN Services(sec)"
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "core_loop_54_v01" {
  name                       = "CORE_LOOP54_v01"
  description                = "CORE LOOPBACK54 Monitoring"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.core_vpn504_v01.id
  shutdown                   = false
  interface_name             = "Loopback54"
  interface_description      = "Monitoring"
  ipv4_address_variable      = "{{var_core_loop54_address}}"
  ipv4_subnet_mask_variable  = "{{var_core_loop54_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_502_v01" {
  name                     = "BGP_502_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_502_ip_address}}"
      description_variable    = "{{var_nb_502_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_502_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_200_v01" {
  name                     = "BGP_200_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_200_ip_address}}"
      description_variable    = "{{var_nb_200_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_200_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_503_v01" {
  name                     = "BGP_503_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_503_ip_address}}"
      description_variable    = "{{var_nb_503_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_503_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_300_v01" {
  name                     = "BGP_300_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_300_ip_address}}"
      description_variable    = "{{var_nb_300_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_300_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_504_v01" {
  name                     = "BGP_504_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  # router_id_variable       = "{{bgp_router_id}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_504_ip_address}}"
      description_variable    = "{{var_nb_504_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_504_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
  ipv4_redistributes = [
    {
      protocol = "omp"
    }
  ]
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_400_v01" {
  name                     = "BGP_400_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_400_ip_address}}"
      description_variable    = "{{var_nb_400_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_400_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_506_v01" {
  name                     = "BGP_506_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_506_ip_address}}"
      description_variable    = "{{var_nb_506_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_506_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
}

resource "sdwan_service_routing_bgp_feature" "core_bgp_600_v01" {
  name                     = "BGP_600_v01"
  description              = "BGP towards legacy core routers"
  feature_profile_id       = sdwan_service_feature_profile.core_service_v01.id
  as_number_variable       = "{{var_bgp_asn}}"
  ipv4_neighbors = [
    {
      address_variable        = "{{var_nb_600_ip_address}}"
      description_variable    = "{{var_nb_600_desc}}"
      shutdown                = false
      remote_as_variable      = "{{var_nb_600_asn}}"
      address_families = [
        {
          family_type            = "ipv4-unicast"
          max_number_of_prefixes = 2000
          threshold              = 75
          policy_type            = "restart"
          restart_interval       = 30
        }
      ]
    }
  ]
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_502_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn502_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_502_v01.id
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_200_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn200_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_200_v01.id
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_503_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn503_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_503_v01.id
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_300_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn300_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_300_v01.id
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_504_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn504_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_504_v01.id
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_400_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn400_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_400_v01.id
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_506_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn506_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_506_v01.id
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "core_bgp_service_associate_600_v01" {
  feature_profile_id             = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id     = sdwan_service_lan_vpn_feature.core_vpn600_v01.id
  service_routing_bgp_feature_id = sdwan_service_routing_bgp_feature.core_bgp_600_v01.id
}


# ERROR during subinterface creation:
# Invalid Payload: doesn't support user settable interface mtu for sub interface
# resource "sdwan_service_lan_vpn_interface_ethernet_feature" "vpn511_gig2_511_v01" {
#   name                       = "VPN511_Gig2_511_v01"
#   # description                = "Legacy DC core routers mgmt int"
#   feature_profile_id         = sdwan_service_feature_profile.service_core_v01.id
#   service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.vpn511_v01.id
#   shutdown                   = false
#   interface_name             = "GigabitEthernet2.511"
#   interface_description      = "Legacy DC core routers mgmt int"
#   ipv4_address               = "172.16.51.1"
#   ipv4_subnet_mask           = "255.255.255.252"
#   ipv4_nat                   = false
#   ipv4_nat_type              = "pool"
# }

resource "sdwan_cli_config_feature" "core_cli_cfg_v01" {
  feature_profile_id = sdwan_cli_feature_profile.core_cli_v01.id
  name               = "CORE_CLI_CFG_v01"
  description        = "Core CLI config"
  # cli_configuration  = "bfd default-dscp 48\nbfd app-route multiplier 6\nbfd app-route poll-interval 600000"
  cli_configuration  = <<-EOT
  interface GigabitEthernet2.511
  description Legacy_cores_mgmt
  encapsulation dot1Q 511
  vrf forwarding 511
  ip address {{var_vpn511_gig2_511_if_address}} {{var_vpn511_gig2_511_if_mask}}
  !
  !Route leaking between VRF 511 and global VRF
  vrf definition 511
    address-family ipv4
    route-replicate from vrf global unicast static
    exit-address-family
  !
  global-address-family ipv4
    route-replicate from vrf 511 unicast connected
    exit-global-af
  !
  interface GigabitEthernet2.502
  description Legacy_cores_BGP
  encapsulation dot1Q 502
  vrf forwarding 502
  ip address {{var_gig2_502_if_address}} {{var_gig2_502_if_mask}}
  !
  interface GigabitEthernet2.200
  description Legacy_cores_BGP
  encapsulation dot1Q 200
  vrf forwarding 200
  ip address {{var_gig2_200_if_address}} {{var_gig2_200_if_mask}}
  !
  interface GigabitEthernet2.503
  description Legacy_cores_BGP
  encapsulation dot1Q 503
  vrf forwarding 503
  ip address {{var_gig2_503_if_address}} {{var_gig2_503_if_mask}}
  !
  interface GigabitEthernet2.300
  description Legacy_cores_BGP
  encapsulation dot1Q 300
  vrf forwarding 300
  ip address {{var_gig2_300_if_address}} {{var_gig2_300_if_mask}}
  !
  interface GigabitEthernet2.504
  description Legacy_cores_BGP
  encapsulation dot1Q 504
  vrf forwarding 504
  ip address {{var_gig2_504_if_address}} {{var_gig2_504_if_mask}}
  !
  interface GigabitEthernet2.400
  description Legacy_cores_BGP
  encapsulation dot1Q 400
  vrf forwarding 400
  ip address {{var_gig2_400_if_address}} {{var_gig2_400_if_mask}}
  !
  interface GigabitEthernet2.506
  description Legacy_cores_BGP
  encapsulation dot1Q 506
  vrf forwarding 506
  ip address {{var_gig2_506_if_address}} {{var_gig2_506_if_mask}}
  !
  interface GigabitEthernet2.600
  description Legacy_cores_BGP
  encapsulation dot1Q 600
  vrf forwarding 600
  ip address {{var_gig2_600_if_address}} {{var_gig2_600_if_mask}}
  EOT
}

################################ Configuration group ##############################
resource "sdwan_configuration_group" "core_config_group_v01" {
  name        = "CG_CORES_v01"
  description = "Configuration group - Cores"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.system_v01.id, 
    sdwan_transport_feature_profile.transport_v01.id, 
    sdwan_service_feature_profile.core_service_v01.id, 
    sdwan_cli_feature_profile.core_cli_v01.id,
  ]
  devices = local.sd-wan_cores
  feature_versions = [
    sdwan_system_basic_feature.system_basic_v01.version,
    sdwan_system_aaa_feature.system_aaa_v01.version,
    # sdwan_system_bfd_feature.system_bfd_v01.version,
    # sdwan_system_logging_feature.system_logging_v01.version,
    sdwan_system_global_feature.system_global_v01.version,
    sdwan_system_omp_feature.system_omp_v01.version,
    sdwan_transport_wan_vpn_feature.transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.transport_wan_vpn_if_eth_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn511_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn502_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn200_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn503_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn300_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn504_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn400_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn506_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn600_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_502_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_200_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_503_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_300_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_504_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_400_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_506_v01.version,
    # sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_600_v01.version,
    # sdwan_service_lan_vpn_interface_ethernet_feature.vpn511_gig2_511_v01.version,
    sdwan_cli_config_feature.core_cli_cfg_v01.version,
  ]
}