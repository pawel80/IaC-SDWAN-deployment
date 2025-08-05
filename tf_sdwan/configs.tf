###################################################################################
################################## SD-WAN cEDGEs ##################################
###################################################################################

################################# Feature profiles ################################
#---------------------------- Feature profiles dual edge1 -------------------------
resource "sdwan_system_feature_profile" "edge1_system_v01" {
  name        = "EDGE1_SYSTEM_v01"
  description = "EDGE1 System settings"
}

resource "sdwan_transport_feature_profile" "edge1_transport_v01" {
  name        = "EDGE1_TRANSPORT_v01"
  description = "EDGE1 Transport and Management config"
}

resource "sdwan_service_feature_profile" "edge1_service_v01" {
  name        = "EDGE1_SERVICES_v01"
  description = "EDGE1 service feature profiles"
}

resource "sdwan_cli_feature_profile" "edge1_cli_v01" {
  name        = "EDGE1_CLI_FEATURE_PROFILE_v01"
  description = "EDGE1 CLI Feature Profile"
}

#---------------------------- Feature profiles dual edge2 -------------------------
resource "sdwan_system_feature_profile" "edge2_system_v01" {
  name        = "EDGE2_SYSTEM_v01"
  description = "EDGE2 System settings"
}

resource "sdwan_transport_feature_profile" "edge2_transport_v01" {
  name        = "EDGE2_TRANSPORT_v01"
  description = "EDGE2 Transport and Management config"
}

resource "sdwan_service_feature_profile" "edge2_service_v01" {
  name        = "EDGE2_SERVICES_v01"
  description = "EDGE2 service feature profiles"
}

resource "sdwan_cli_feature_profile" "edge2_cli_v01" {
  name        = "EDGE2_CLI_FEATURE_PROFILE_v01"
  description = "EDGE2 CLI Feature Profile"
}

#--------------------------- Feature profiles single edge -------------------------
resource "sdwan_system_feature_profile" "edge_single_system_v01" {
  name        = "EDGE_SINGLE_SYSTEM_v01"
  description = "EDGE single System settings"
}

resource "sdwan_transport_feature_profile" "edge_single_transport_v01" {
  name        = "EDGE_SINGLE_TRANSPORT_v01"
  description = "EDGE single Transport and Management config"
}

resource "sdwan_service_feature_profile" "edge_single_service_v01" {
  name        = "EDGE_SINGLE_SERVICES_v01"
  description = "EDGE single service feature profiles"
}

resource "sdwan_cli_feature_profile" "edge_single_cli_v01" {
  name        = "EDGE_SINGLE_CLI_FEATURE_PROFILE_v01"
  description = "EDGE single CLI Feature Profile"
}

##################################### Features ####################################
#-------------------------------- Features dual edge1 -----------------------------
resource "sdwan_system_basic_feature" "edge1_system_basic_v01" {
  name               = "EDGE1_SYSTEM_BASIC_v01"
  feature_profile_id = sdwan_system_feature_profile.edge1_system_v01.id
}

resource "sdwan_system_aaa_feature" "edge1_system_aaa_v01" {
  name               = "EDGE1_SYSTEM_AAA_v01"
  feature_profile_id = sdwan_system_feature_profile.edge1_system_v01.id
  server_auth_order  = ["local"]
  users = [{
    name     = var.admin_account
    password = var.admin_account_pass
  }]
}

resource "sdwan_system_global_feature" "edge1_system_global_v01" {
  name               = "EDGE1_SYSTEM_GLOBAL_v01"
  feature_profile_id = sdwan_system_feature_profile.edge1_system_v01.id
}

resource "sdwan_system_omp_feature" "edge1_system_omp_v01" {
  name                        = "EDGE1_SYSTEM_OMP_v01"
  feature_profile_id          = sdwan_system_feature_profile.edge1_system_v01.id
  # paths_advertised_per_prefix = 6
}

# resource "sdwan_system_bfd_feature" "system_bfd_v01" {
#   name               = "SYSTEM_BFD_v01"
#   feature_profile_id = sdwan_system_feature_profile.edge1_system_v01.id
# }

# resource "sdwan_system_logging_feature" "system_logging_v01" {
#   name               = "SYSTEM_LOGGING_v01"
#   feature_profile_id = sdwan_system_feature_profile.edge1_system_v01.id
# }

resource "sdwan_transport_wan_vpn_feature" "edge1_transport_wan_vpn_v01" {
  name                        = "EDGE1_TRANSPORT_WAN_VPN0_v01"
  feature_profile_id          = sdwan_transport_feature_profile.edge1_transport_v01.id
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

resource "sdwan_service_lan_vpn_feature" "edge1_vpn504_v01" {
  name                       = "EDGE1_VPN504_v01"
  description                = "EDGE1 VPN504 SD-WAN Monitoring(open)"
  feature_profile_id         = sdwan_service_feature_profile.edge1_service_v01.id
  vpn                        = 504
  config_description         = "EDGE1 VPN504 SD-WAN Monitoring(open)"
}

resource "sdwan_service_lan_vpn_feature" "edge1_vpn400_v01" {
  name                       = "EDGE1_VPN400_v01"
  description                = "EDGE1 VPN400 SD-WAN Services(open)"
  feature_profile_id         = sdwan_service_feature_profile.edge1_service_v01.id
  vpn                        = 400
  config_description         = "EDGE1 VPN400 SD-WAN Services(open)"
}

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "edge1_vpn0_if_eth1_v01" {
  name                         = "EDGE1_VPN0_IF_ETH1_v01"
  feature_profile_id           = sdwan_transport_feature_profile.edge1_transport_v01.id
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.edge1_transport_wan_vpn_v01.id
  interface_name               = "GigabitEthernet1"
  shutdown                     = false
  interface_description        = "WAN"
  ipv4_configuration_type      = "static"
  ipv4_address_variable        = "{{var_vpn0_gig1_if_address}}"
  ipv4_subnet_mask_variable    = "{{var_vpn0_gig1_if_mask}}"
  tunnel_interface             = true
  tunnel_interface_color       = "private1"
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

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "edge1_vpn0_if_eth3_v01" {
  name                         = "EDGE1_TLOC_EXT_VPN0_IF_ETH3_v01"
  feature_profile_id           = sdwan_transport_feature_profile.edge1_transport_v01.id
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.edge1_transport_wan_vpn_v01.id
  interface_name               = "GigabitEthernet3"
  shutdown                     = false
  interface_description        = "TLOC_EXT"
  ipv4_configuration_type      = "static"
  ipv4_address_variable        = "{{var_vpn0_gig3_if_address}}"
  ipv4_subnet_mask_variable    = "{{var_vpn0_gig3_if_mask}}"
  tunnel_interface             = false
  tloc_extension               = "GigabitEthernet1"
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "edge1_loop_54_v01" {
  name                       = "EDGE1_LOOP54_v01"
  description                = "EDGE1 LOOPBACK54 Monitoring"
  feature_profile_id         = sdwan_service_feature_profile.edge1_service_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.edge1_vpn504_v01.id
  shutdown                   = false
  interface_name             = "Loopback54"
  interface_description      = "Monitoring(open)"
  ipv4_address_variable      = "{{var_edge_loop54_address}}"
  ipv4_subnet_mask_variable  = "{{var_edge_loop54_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

resource "sdwan_cli_config_feature" "edge1_cli_cfg_v01" {
  feature_profile_id = sdwan_cli_feature_profile.edge1_cli_v01.id
  name               = "EDGE1_CLI_CFG_v01"
  description        = "EDGE1 CLI config"
  cli_configuration  = <<-EOT
  interface GigabitEthernet2
  description NOT-USED
  shutdown
  !
  interface GigabitEthernet4
  description NOT-USED
  shutdown
  !
  EOT
}

#-------------------------------- Features dual edge2 -----------------------------
resource "sdwan_system_basic_feature" "edge2_system_basic_v01" {
  name               = "EDGE2_SYSTEM_BASIC_v01"
  feature_profile_id = sdwan_system_feature_profile.edge2_system_v01.id
}

resource "sdwan_system_aaa_feature" "edge2_system_aaa_v01" {
  name               = "EDGE2_SYSTEM_AAA_v01"
  feature_profile_id = sdwan_system_feature_profile.edge2_system_v01.id
  server_auth_order  = ["local"]
  users = [{
    name     = var.admin_account
    password = var.admin_account_pass
  }]
}

resource "sdwan_system_global_feature" "edge2_system_global_v01" {
  name               = "EDGE2_SYSTEM_GLOBAL_v01"
  feature_profile_id = sdwan_system_feature_profile.edge2_system_v01.id
}

resource "sdwan_system_omp_feature" "edge2_system_omp_v01" {
  name                        = "EDGE2_SYSTEM_OMP_v01"
  feature_profile_id          = sdwan_system_feature_profile.edge2_system_v01.id
  # paths_advertised_per_prefix = 6
  ecmp_limit                  = 6
}

resource "sdwan_transport_wan_vpn_feature" "edge2_transport_wan_vpn_v01" {
  name                        = "EDGE2_TRANSPORT_WAN_VPN0_v01"
  feature_profile_id          = sdwan_transport_feature_profile.edge2_transport_v01.id
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
          address_variable        = "{{var_edge2_tloc_ext_gtw}}"
          administrative_distance = 1
        }
      ]
    },
    {
      network_address = "172.16.11.0"
      subnet_mask     = "255.255.255.0"
      gateway         = "nextHop"
      next_hops = [
        {
          address_variable        = "{{var_edge2_def_gtw}}"
          administrative_distance = 1
        }
      ]
    },
    {
      network_address = "172.16.66.0"
      subnet_mask     = "255.255.255.0"
      gateway         = "nextHop"
      next_hops = [
        {
          address_variable        = "{{var_edge2_def_gtw}}"
          administrative_distance = 1
        }
      ]
    }
  ]
}

resource "sdwan_service_lan_vpn_feature" "edge2_vpn506_v01" {
  name                       = "EDGE2_VPN506_v01"
  description                = "EDGE2 VPN506 SD-WAN Monitoring(secured)"
  feature_profile_id         = sdwan_service_feature_profile.edge2_service_v01.id
  vpn                        = 506
  config_description         = "EDGE2 VPN506 SD-WAN Monitoring(secured)"
}

resource "sdwan_service_lan_vpn_feature" "edge2_vpn600_v01" {
  name                       = "EDGE2_VPN600_v01"
  description                = "EDGE2 VPN600 SD-WAN Services(secured)"
  feature_profile_id         = sdwan_service_feature_profile.edge2_service_v01.id
  vpn                        = 600
  config_description         = "EDGE2 VPN600 SD-WAN Services(secured)"
}

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "edge2_vpn0_if_eth2_v01" {
  name                                     = "EDGE2_TRANSPORT_WAN_VPN0_IF_ETH2_v01"
  feature_profile_id                       = sdwan_transport_feature_profile.edge2_transport_v01.id
  transport_wan_vpn_feature_id             = sdwan_transport_wan_vpn_feature.edge2_transport_wan_vpn_v01.id
  interface_name                           = "GigabitEthernet2"
  shutdown                                 = false
  interface_description                    = "WAN"
  ipv4_configuration_type                  = "static"
  ipv4_address_variable                    = "{{var_edge2_vpn0_gig2_if_address}}"
  ipv4_subnet_mask_variable                = "{{var_edge2_vpn0_gig2_if_mask}}"
  tunnel_interface                         = true
  tunnel_interface_color                   = "private2"
  tunnel_interface_color_restrict          = true
  tunnel_interface_max_control_connections = 0
  tunnel_interface_allow_icmp              = true
  tunnel_interface_allow_dns               = true
  tunnel_interface_allow_ntp               = true
  tunnel_interface_encapsulations          = [
    {
      encapsulation = "ipsec"
    }
  ]
}

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "edge2_vpn0_if_eth3_v01" {
  name                         = "EDGE2_TLOC_EXT_VPN0_IF_ETH3_v01"
  feature_profile_id           = sdwan_transport_feature_profile.edge2_transport_v01.id
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.edge2_transport_wan_vpn_v01.id
  interface_name               = "GigabitEthernet3"
  shutdown                     = false
  interface_description        = "TLOC_EXT"
  ipv4_configuration_type      = "static"
  ipv4_address_variable        = "{{var_edge2_vpn0_gig3_if_address}}"
  ipv4_subnet_mask_variable    = "{{var_edge2_vpn0_gig3_if_mask}}"
  # tloc_extension               = "GigabitEthernet1"
  tunnel_interface             = true
  tunnel_interface_color       = "private1"
  tunnel_interface_allow_icmp  = true
  tunnel_interface_allow_dns   = true
  tunnel_interface_allow_ntp   = true
  tunnel_interface_encapsulations = [
    {
      encapsulation = "gre"
    }
  ]
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "edge2_loop_56_v01" {
  name                       = "EDGE2_LOOP56_v01"
  description                = "EDGE2 LOOPBACK56 Monitoring"
  feature_profile_id         = sdwan_service_feature_profile.edge2_service_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.edge2_vpn506_v01.id
  shutdown                   = false
  interface_name             = "Loopback56"
  interface_description      = "Monitoring(secured)"
  ipv4_address_variable      = "{{var_edge2_loop56_address}}"
  ipv4_subnet_mask_variable  = "{{var_edge2_loop56_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

resource "sdwan_cli_config_feature" "edge2_cli_cfg_v01" {
  feature_profile_id = sdwan_cli_feature_profile.edge2_cli_v01.id
  name               = "EDGE2_CLI_CFG_v01"
  description        = "EDGE2 CLI config"
  cli_configuration  = <<-EOT
  interface GigabitEthernet1
  description NOT-USED
  shutdown
  !
  interface GigabitEthernet4
  description NOT-USED
  shutdown
  !
  EOT
}

#------------------------------- Features single edge -----------------------------
resource "sdwan_system_basic_feature" "edge_single_system_basic_v01" {
  name               = "EDGE_SINGLE_SYSTEM_BASIC_v01"
  feature_profile_id = sdwan_system_feature_profile.edge_single_system_v01.id
}

resource "sdwan_system_aaa_feature" "edge_single_system_aaa_v01" {
  name               = "EDGE_SINGLE_SYSTEM_AAA_v01"
  feature_profile_id = sdwan_system_feature_profile.edge_single_system_v01.id
  server_auth_order  = ["local"]
  users = [{
    name     = var.admin_account
    password = var.admin_account_pass
  }]
}

resource "sdwan_system_global_feature" "edge_single_system_global_v01" {
  name               = "EDGE_SINGLE_SYSTEM_GLOBAL_v01"
  feature_profile_id = sdwan_system_feature_profile.edge_single_system_v01.id
}

resource "sdwan_system_omp_feature" "edge_single_system_omp_v01" {
  name                        = "EDGE_SINGLE_SYSTEM_OMP_v01"
  feature_profile_id          = sdwan_system_feature_profile.edge_single_system_v01.id
  # paths_advertised_per_prefix = 6
}

resource "sdwan_transport_wan_vpn_feature" "edge_single_transport_wan_vpn_v01" {
  name                        = "EDGE_SINGLE_TRANSPORT_WAN_VPN0_v01"
  feature_profile_id          = sdwan_transport_feature_profile.edge_single_transport_v01.id
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
          address_variable        = "{{var_edge_single_def_gtw}}"
          administrative_distance = 1
        }
      ]
    }
  ]
}

resource "sdwan_service_lan_vpn_feature" "edge_single_vpn504_v01" {
  name                       = "EDGE_SINGLE_VPN504_v01"
  description                = "EDGE SINGLE VPN504 SD-WAN Monitoring(open)"
  feature_profile_id         = sdwan_service_feature_profile.edge_single_service_v01.id
  vpn                        = 504
  config_description         = "EDGE SINGLE VPN504 SD-WAN Monitoring(open)"
}

resource "sdwan_service_lan_vpn_feature" "edge_single_vpn400_v01" {
  name                       = "EDGE_SINGLE_VPN400_v01"
  description                = "EDGE SINGLE VPN400 SD-WAN Services(open)"
  feature_profile_id         = sdwan_service_feature_profile.edge_single_service_v01.id
  vpn                        = 400
  config_description         = "EDGE SINGLE VPN400 SD-WAN Services(open)"
}

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "edge_single_vpn0_if_eth1_v01" {
  name                         = "EDGE_SINGLE_TRANSPORT_WAN_VPN0_IF_ETH1_v01"
  feature_profile_id           = sdwan_transport_feature_profile.edge_single_transport_v01.id
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.edge_single_transport_wan_vpn_v01.id
  interface_name               = "GigabitEthernet1"
  shutdown                     = false
  interface_description        = "WAN"
  ipv4_configuration_type      = "static"
  ipv4_address_variable        = "{{var_edge_single_vpn0_gig1_if_address}}"
  ipv4_subnet_mask_variable    = "{{var_edge_single_vpn0_gig1_if_mask}}"
  tunnel_interface             = true
  tunnel_interface_color       = "private1"
  tunnel_interface_allow_icmp  = true
  tunnel_interface_allow_dns   = true
  tunnel_interface_allow_ntp   = true
  tunnel_interface_encapsulations = [
    {
      encapsulation = "gre"
    }
  ]
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "edge_single_loop_54_v01" {
  name                       = "EDGE_SINGLE_LOOP54_v01"
  description                = "EDGE SINGLE LOOPBACK54 Monitoring"
  feature_profile_id         = sdwan_service_feature_profile.edge_single_service_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.edge_single_vpn504_v01.id
  shutdown                   = false
  interface_name             = "Loopback54"
  interface_description      = "Monitoring(open)"
  ipv4_address_variable      = "{{var_edge_single_loop54_address}}"
  ipv4_subnet_mask_variable  = "{{var_edge_single_loop54_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

resource "sdwan_cli_config_feature" "edge_single_cli_cfg_v01" {
  feature_profile_id = sdwan_cli_feature_profile.edge_single_cli_v01.id
  name               = "EDGE_SINGLE_CLI_CFG_v01"
  description        = "EDGE SINGLE CLI config"
  cli_configuration  = <<-EOT
  interface GigabitEthernet2
  description NOT-USED
  shutdown
  !
  interface GigabitEthernet3
  description NOT-USED
  shutdown
  !
  interface GigabitEthernet4
  description NOT-USED
  shutdown
  !
  EOT
}

################################ Configuration group ##############################
#-------------------------- Configuration group dual edge1 ------------------------
resource "sdwan_configuration_group" "edge_config_group_v01" {
  name        = "CG_EDGE1_v01"
  description = "Configuration group - Edge1 dual"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.edge1_system_v01.id, 
    sdwan_transport_feature_profile.edge1_transport_v01.id,
    sdwan_service_feature_profile.edge1_service_v01.id,
    sdwan_cli_feature_profile.edge1_cli_v01.id,
  ]
  devices = local.sdwan_edges_dual1
  feature_versions = [
    sdwan_system_basic_feature.edge1_system_basic_v01.version,
    sdwan_system_aaa_feature.edge1_system_aaa_v01.version,
    # sdwan_system_bfd_feature.edge1_system_bfd_v01.version,
    # sdwan_system_logging_feature.edge1_system_logging_v01.version,
    sdwan_system_global_feature.edge1_system_global_v01.version,
    sdwan_system_omp_feature.edge1_system_omp_v01.version,
    sdwan_transport_wan_vpn_feature.edge1_transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.edge1_vpn0_if_eth1_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.edge1_vpn0_if_eth3_v01.version,
    sdwan_service_lan_vpn_feature.edge1_vpn504_v01.version,
    sdwan_service_lan_vpn_feature.edge1_vpn400_v01.version,
    sdwan_service_lan_vpn_interface_ethernet_feature.edge1_loop_54_v01.version,
    sdwan_cli_config_feature.edge1_cli_cfg_v01.version,
  ]
}

#-------------------------- Configuration group dual edge2 ------------------------
resource "sdwan_configuration_group" "edge2_config_group_v01" {
  name        = "CG_EDGE2_v01"
  description = "Configuration group - Edge2 dual"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.edge2_system_v01.id, 
    sdwan_transport_feature_profile.edge2_transport_v01.id,
    sdwan_service_feature_profile.edge2_service_v01.id,
    sdwan_cli_feature_profile.edge2_cli_v01.id,
  ]
  devices = local.sdwan_edges_dual2
  feature_versions = [
    sdwan_system_basic_feature.edge2_system_basic_v01.version,
    sdwan_system_aaa_feature.edge2_system_aaa_v01.version,
    sdwan_system_global_feature.edge2_system_global_v01.version,
    sdwan_system_omp_feature.edge2_system_omp_v01.version,
    sdwan_transport_wan_vpn_feature.edge2_transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.edge2_vpn0_if_eth2_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.edge2_vpn0_if_eth3_v01.version,
    sdwan_service_lan_vpn_feature.edge2_vpn506_v01.version,
    sdwan_service_lan_vpn_feature.edge2_vpn600_v01.version,
    sdwan_service_lan_vpn_interface_ethernet_feature.edge2_loop_56_v01.version,
    sdwan_cli_config_feature.edge2_cli_cfg_v01.version,
  ]
}

#------------------------- Configuration group single edge ------------------------
resource "sdwan_configuration_group" "edge_single_config_group_v01" {
  name        = "CG_EDGE_SINGLE_v01"
  description = "Configuration group - Edge single"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.edge_single_system_v01.id, 
    sdwan_transport_feature_profile.edge_single_transport_v01.id,
    sdwan_service_feature_profile.edge_single_service_v01.id,
    sdwan_cli_feature_profile.edge_single_cli_v01.id,
  ]
  devices = local.sdwan_edges_single
  feature_versions = [
    sdwan_system_basic_feature.edge_single_system_basic_v01.version,
    sdwan_system_aaa_feature.edge_single_system_aaa_v01.version,
    sdwan_system_global_feature.edge_single_system_global_v01.version,
    sdwan_system_omp_feature.edge_single_system_omp_v01.version,
    sdwan_transport_wan_vpn_feature.edge_single_transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.edge_single_vpn0_if_eth1_v01.version,
    sdwan_service_lan_vpn_feature.edge_single_vpn504_v01.version,
    sdwan_service_lan_vpn_feature.edge_single_vpn400_v01.version,
    sdwan_service_lan_vpn_interface_ethernet_feature.edge_single_loop_54_v01.version,
    sdwan_cli_config_feature.edge_single_cli_cfg_v01.version,
  ]
}



###################################################################################
################################## SD-WAN COREs ###################################
###################################################################################

################################# Feature profiles ################################
resource "sdwan_system_feature_profile" "core_system_v01" {
  name        = "CORE_SYSTEM_v01"
  description = "CORE System settings"
}

resource "sdwan_transport_feature_profile" "core_transport_v01" {
  name        = "CORE_TRANSPORT_v01"
  description = "CORE Transport and Management config"
}

resource "sdwan_service_feature_profile" "core_service_v01" {
  name        = "CORE_SERVICES_v01"
  description = "CORE service feature profiles"
}

resource "sdwan_cli_feature_profile" "core_cli_v01" {
  name        = "CORE_CLI_FEATURE_PROFILE_v01"
  description = "CORE CLI Feature Profile"
}

##################################### Features ####################################
resource "sdwan_system_basic_feature" "core_system_basic_v01" {
  name               = "CORE_SYSTEM_BASIC_v01"
  feature_profile_id = sdwan_system_feature_profile.core_system_v01.id
}

resource "sdwan_system_aaa_feature" "core_system_aaa_v01" {
  name               = "CORE_SYSTEM_AAA_v01"
  feature_profile_id = sdwan_system_feature_profile.core_system_v01.id
  server_auth_order  = ["local"]
  users = [{
    name     = var.admin_account
    password = var.admin_account_pass
  }]
}

resource "sdwan_system_global_feature" "core_system_global_v01" {
  name               = "CORE_SYSTEM_GLOBAL_v01"
  feature_profile_id = sdwan_system_feature_profile.core_system_v01.id
}

resource "sdwan_system_omp_feature" "core_system_omp_v01" {
  name                        = "CORE_SYSTEM_OMP_v01"
  feature_profile_id          = sdwan_system_feature_profile.core_system_v01.id
  advertise_ipv4_bgp          = true
  # paths_advertised_per_prefix = 6
}

resource "sdwan_transport_wan_vpn_feature" "core_transport_wan_vpn_v01" {
  name                        = "CORE_TRANSPORT_WAN_VPN0_v01"
  feature_profile_id          = sdwan_transport_feature_profile.core_transport_v01.id
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
    },
    # {
    #   network_address = "0.0.0.0"
    #   subnet_mask     = "0.0.0.0"
    #   gateway         = "nextHop"
    #   next_hops = [
    #     {
    #       address_variable        = "{{var_def_sec_gtw}}"
    #       administrative_distance = 1
    #     }
    #   ]
    # },
    {
      network_address = "172.16.11.0"
      subnet_mask     = "255.255.255.0"
      gateway         = "nextHop"
      next_hops = [
        {
          address_variable        = "{{var_sec_gtw}}"
          administrative_distance = 1
        }
      ]
    },
    {
      network_address = "172.16.66.0"
      subnet_mask     = "255.255.255.0"
      gateway         = "nextHop"
      next_hops = [
        {
          address_variable        = "{{var_sec_gtw}}"
          administrative_distance = 1
        }
      ]
    }
  ]
}

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "core_transport_wan_vpn_if_eth1_v01" {
  name                         = "CORE_TRANSPORT_WAN_VPN0_IF_ETH1_v01"
  feature_profile_id           = sdwan_transport_feature_profile.core_transport_v01.id
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.core_transport_wan_vpn_v01.id
  interface_name               = "GigabitEthernet1"
  shutdown                     = false
  interface_description        = "WAN"
  ipv4_configuration_type      = "static"
  ipv4_address_variable        = "{{var_vpn0_gig1_if_address}}"
  ipv4_subnet_mask_variable    = "{{var_vpn0_gig1_if_mask}}"
  tunnel_interface             = true
  tunnel_interface_color       = "private1"
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

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "core_transport_wan_vpn_if_eth3_v01" {
  name                                     = "CORE_TRANSPORT_WAN_VPN0_IF_ETH3_v01"
  feature_profile_id                       = sdwan_transport_feature_profile.core_transport_v01.id
  transport_wan_vpn_feature_id             = sdwan_transport_wan_vpn_feature.core_transport_wan_vpn_v01.id
  interface_name                           = "GigabitEthernet3"
  shutdown                                 = false
  interface_description                    = "WAN"
  ipv4_configuration_type                  = "static"
  ipv4_address_variable                    = "{{var_vpn0_gig3_if_address}}"
  ipv4_subnet_mask_variable                = "{{var_vpn0_gig3_if_mask}}"
  tunnel_interface                         = true
  tunnel_interface_color                   = "private2"
  tunnel_interface_color_restrict          = true
  tunnel_interface_max_control_connections = 0
  tunnel_interface_allow_icmp              = true
  tunnel_interface_allow_dns               = true
  tunnel_interface_allow_ntp               = true
  tunnel_interface_encapsulations          = [
    {
      encapsulation = "ipsec"
    }
  ]
}

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
  interface_description      = "Monitoring(open)"
  ipv4_address_variable      = "{{var_core_loop54_address}}"
  ipv4_subnet_mask_variable  = "{{var_core_loop54_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "core_loop_56_v01" {
  name                       = "CORE_LOOP56_v01"
  description                = "CORE LOOPBACK56 Monitoring"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.core_vpn506_v01.id
  shutdown                   = false
  interface_name             = "Loopback56"
  interface_description      = "Monitoring(secured)"
  ipv4_address_variable      = "{{var_core_loop56_address}}"
  ipv4_subnet_mask_variable  = "{{var_core_loop56_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "core_loop_20_v01" {
  name                       = "CORE_LOOP20_v01"
  description                = "CORE LOOPBACK20 GRE source"
  feature_profile_id         = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.core_vpn200_v01.id
  shutdown                   = false
  interface_name             = "Loopback20"
  interface_description      = "Service(open) GRE source"
  ipv4_address_variable      = "{{var_core_loop20_address}}"
  ipv4_subnet_mask_variable  = "{{var_core_loop20_mask}}"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

resource "sdwan_service_lan_vpn_interface_gre_feature" "core_vpn200_GRE1_v01" {
  name                                     = "CORE_VPN200_GRE1_v01"
  description                              = "GRE tunnel towards legacy Edge routers"
  feature_profile_id                       = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id               = sdwan_service_lan_vpn_feature.core_vpn200_v01.id
  interface_name                           = "gre1"
  interface_description                    = "GRE tunnel towards legacy Edge routers"
  ipv4_address_variable                    = "{{var_core_GRE1_tunnel_ip}}"
  ipv4_subnet_mask_variable                = "{{var_core_GRE1_tunnel_mask}}"
  shutdown                                 = false
  tunnel_source_ipv4_address_variable      = "{{var_core_GRE1_src}}"
  tunnel_destination_ipv4_address_variable = "{{var_core_GRE1_dst}}"
  ip_mtu                                   = 1500
  tcp_mss                                  = 1460
  clear_dont_fragment                      = false
  application_tunnel_type                  = "none"
}

resource "sdwan_service_lan_vpn_interface_gre_feature" "core_vpn200_GRE2_v01" {
  name                                     = "CORE_VPN200_GRE2_v01"
  description                              = "GRE tunnel towards legacy Edge routers"
  feature_profile_id                       = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id               = sdwan_service_lan_vpn_feature.core_vpn200_v01.id
  interface_name                           = "gre2"
  interface_description                    = "GRE tunnel towards legacy Edge routers"
  ipv4_address_variable                    = "{{var_core_GRE2_tunnel_ip}}"
  ipv4_subnet_mask_variable                = "{{var_core_GRE2_tunnel_mask}}"
  shutdown                                 = false
  tunnel_source_ipv4_address_variable      = "{{var_core_GRE2_src}}"
  tunnel_destination_ipv4_address_variable = "{{var_core_GRE2_dst}}"
  ip_mtu                                   = 1500
  tcp_mss                                  = 1460
  clear_dont_fragment                      = false
  application_tunnel_type                  = "none"
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
      # protocol = "connected"
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

resource "sdwan_service_routing_ospf_feature" "core_ospf_200_v01" {
  name                                      = "OSPF_200_v01"
  description                               = "OSPF for Legacy routers"
  feature_profile_id                        = sdwan_service_feature_profile.core_service_v01.id
  router_id_variable                        = "{{var_core_loop20_address}}"
  redistributes = [
    {
      protocol = "bgp"
    }
  ]
  areas = [
    {
      area_number = 0
      interfaces = [
        {
          name                       = "Tunnel15000512"
          network_type               = "point-to-point"
          passive_interface          = false
        }
      ]
      # ranges = [
      #   {
      #     ip_address   = "10.1.1.0"
      #     subnet_mask  = "255.255.255.0"
      #     cost         = 1
      #     no_advertise = false
      #   }
      # ]
    }
  ]
}

resource "sdwan_service_lan_vpn_feature_associate_routing_ospf_feature" "core_ospf_service_associate_v01" {
  feature_profile_id              = sdwan_service_feature_profile.core_service_v01.id
  service_lan_vpn_feature_id      = sdwan_service_lan_vpn_feature.core_vpn200_v01.id
  service_routing_ospf_feature_id = sdwan_service_routing_ospf_feature.core_ospf_200_v01.id
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
  !Route leaking between VRF 200 and global VRF
  vrf definition 200
    address-family ipv4
    route-replicate from vrf global unicast static
    exit-address-family
  !
  global-address-family ipv4
    route-replicate from vrf 200 unicast connected
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
    sdwan_system_feature_profile.core_system_v01.id, 
    sdwan_transport_feature_profile.core_transport_v01.id, 
    sdwan_service_feature_profile.core_service_v01.id, 
    sdwan_cli_feature_profile.core_cli_v01.id,
  ]
  devices = local.sdwan_cores
  feature_versions = [
    sdwan_system_basic_feature.core_system_basic_v01.version,
    sdwan_system_aaa_feature.core_system_aaa_v01.version,
    # sdwan_system_bfd_feature.system_bfd_v01.version,
    # sdwan_system_logging_feature.system_logging_v01.version,
    sdwan_system_global_feature.core_system_global_v01.version,
    sdwan_system_omp_feature.core_system_omp_v01.version,
    sdwan_transport_wan_vpn_feature.core_transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.core_transport_wan_vpn_if_eth1_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn511_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn502_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn200_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn503_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn300_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn504_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn400_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn506_v01.version,
    sdwan_service_lan_vpn_feature.core_vpn600_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_502_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_200_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_503_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_300_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_504_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_400_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_506_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_bgp_feature.core_bgp_service_associate_600_v01.version,
    # sdwan_service_lan_vpn_interface_ethernet_feature.vpn511_gig2_511_v01.version,
    sdwan_service_lan_vpn_interface_ethernet_feature.core_loop_54_v01.version,
    sdwan_service_lan_vpn_interface_ethernet_feature.core_loop_56_v01.version,
    sdwan_service_lan_vpn_interface_gre_feature.core_vpn200_GRE1_v01.version,
    sdwan_service_lan_vpn_interface_gre_feature.core_vpn200_GRE2_v01.version,
    sdwan_service_routing_ospf_feature.core_ospf_200_v01.version,
    sdwan_service_lan_vpn_feature_associate_routing_ospf_feature.core_ospf_service_associate_v01.version,
    sdwan_cli_config_feature.core_cli_cfg_v01.version,
  ]
}