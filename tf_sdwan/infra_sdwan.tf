###################################################################################
###################################### EDGES ######################################
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
  name               = "SYSTEM_OMP_v01"
  feature_profile_id = sdwan_system_feature_profile.system_v01.id
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
  # secondary_dns_address_ipv4_variable  = "{{var_dns_secondary}}"
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
  ipv4_address_variable        = "{{var_vpn0_if_address}}"
  ipv4_subnet_mask_variable    = "{{var_vpn0_if_mask}}"

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

################################ Configuration group ##############################
resource "sdwan_configuration_group" "config_group_v01" {
  name        = "CG_MN_DUAL_TLOC_E_v01"
  description = "Configuration group - Edges"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.system_v01.id, 
    sdwan_transport_feature_profile.transport_v01.id
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
  ]
}

###################################################################################
###################################### CORES ######################################
###################################################################################

################################# Feature profiles ################################
resource "sdwan_service_feature_profile" "service_core_v01" {
  name        = "SERVICE_CORES_v01"
  description = "Core service feature profiles"
}

##################################### Features ####################################
resource "sdwan_service_lan_vpn_feature" "vpn511_v01" {
  name                       = "VPN511_v01"
  description                = "VPN511 Legacy DC core routers mgmt"
  feature_profile_id         = sdwan_service_feature_profile.service_core_v01.id
  vpn                        = 511
  config_description         = "VPN511 - Legacy DC core routers mgmt"
  ipv4_static_routes = [
    {
      network_address = "0.0.0.0"
      subnet_mask     = "0.0.0.0"
      vpn             = true
    }
  ]
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "vpn511_gig2_v01" {
  name                       = "VPN511_Gig2_v01"
  # description                = "Legacy DC core routers mgmt int"
  feature_profile_id         = sdwan_service_feature_profile.service_core_v01.id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.vpn511_v01.id
  shutdown                   = false
  interface_name             = "GigabitEthernet2"
  interface_description      = "Legacy DC core routers mgmt int"
  ipv4_address               = "172.16.51.1"
  ipv4_subnet_mask           = "255.255.255.252"
  ipv4_nat                   = false
  ipv4_nat_type              = "pool"
}

################################ Configuration group ##############################
resource "sdwan_configuration_group" "config_group_core_v01" {
  name        = "CG_CORES_v01"
  description = "Configuration group - Cores"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.system_v01.id, 
    sdwan_transport_feature_profile.transport_v01.id,
    sdwan_service_feature_profile.service_core_v01.id
  ]
  devices = local.sd-wan_cores
  feature_versions = [
    sdwan_system_basic_feature.system_basic_v01.version,
    sdwan_system_aaa_feature.system_aaa_v01.version,
    # sdwan_system_bfd_feature.system_bfd_v01.version,
    sdwan_system_global_feature.system_global_v01.version,
    # sdwan_system_logging_feature.system_logging_v01.version,
    sdwan_system_omp_feature.system_omp_v01.version,
    sdwan_transport_wan_vpn_feature.transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.transport_wan_vpn_if_eth_v01.version,
    sdwan_service_lan_vpn_feature.vpn511_v01.version,
    sdwan_service_lan_vpn_interface_ethernet_feature.vpn511_gig2_v01.version,
  ]
}