# FEATURE PROFILES:
resource "sdwan_system_feature_profile" "system_v01" {
  name        = "SYSTEM_v01"
  description = "System settings for all of the sites"
}

resource "sdwan_transport_feature_profile" "transport_v01" {
  name        = "TRANSPORT_v01"
  description = "Transport and Management config"
}

resource "sdwan_system_feature_profile" "system_01" {
  name        = "system_01"
  description = "My system feature profile"
}

resource "sdwan_transport_feature_profile" "transport_01" {
  name        = "transport_01"
  description = "My transport feature profile"
}


# FEATURES (for FEATURE PROFILES):
resource "sdwan_system_basic_feature" "system_basic_v01" {
  name               = "SYSTEM_BASIC_v01"
  feature_profile_id = sdwan_system_feature_profile.system_v01.id
}

resource "sdwan_system_aaa_feature" "system_aaa_v01" {
  name               = "SYSTEM_AAA_v01"
  feature_profile_id = sdwan_system_feature_profile.system_v01.id
  server_auth_order  = ["local"]
  users = [{
    name     = "admin"
    password = "admin"
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
  name               = "TRANSPORT_WAN_VPN0_v01"
  feature_profile_id = sdwan_transport_feature_profile.transport_v01.id
  vpn                = 0
  primary_dns_address_ipv4   = "8.8.8.8"
  # secondary_dns_address_ipv4 = "1.1.1.1"
  # secondary_dns_address_ipv4_variable  = "var_dns2"
  ipv4_static_routes = [
    {
      network_address = "0.0.0.0"
      subnet_mask     = "0.0.0.0"
      gateway         = "nextHop"
      next_hops = [
        {
          address                 = "172.16.10.1"
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
  ipv4_address                 = "172.16.10.2"
  ipv4_subnet_mask             = "255.255.255.252"

  tunnel_interface             = true
  tunnel_interface_color       = "biz-internet"
  tunnel_interface_allow_icmp  = true
  tunnel_interface_allow_dns   = true
  tunnel_interface_allow_ntp   = true
  # tunnel_interface_allow_netconf_variable = "var_tunnel_netconf"
  tunnel_interface_encapsulations = [
    {
      encapsulation = "gre"
    }
  ]
}


# CONFIGURATION GROUP:
resource "sdwan_configuration_group" "config_group_v01" {
  name        = "CG_MN_DUAL_TLOC_E_v01"
  description = "My config group"
  solution     = "sdwan"
  feature_profile_ids = [sdwan_system_feature_profile.system_v01.id, sdwan_transport_feature_profile.transport_v01.id]
  devices = [
    {
    id     = "C8K-0004C57D-A2B1-4D3D-8F7A-ABA9D3AF1D8D"
    deploy = true
    variables = [
      {
        name = "host_name"
        value = "S1R1"
      },
      {
        name = "pseudo_commit_timer"
        value = 0
      },
      {
        name = "site_id"
        value = 101
      },
      {
        name = "system_ip"
        value = "11.1.1.1"
      },
      {
        name = "ipv6_strict_control"
        value = "false"
      },
      # {
      #   name = "var_dns2"
      #   value = "1.2.3.4"
      # }
      # {
      #   name = "var_tunnel_netconf"
      #   value = true
      # }
      ]
    }
  ]
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

