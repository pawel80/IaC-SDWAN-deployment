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
  feature_profile_id = sdwan_system_feature_profile.system_01.id
}

# resource "sdwan_system_bfd_feature" "system_bfd_v01" {
#   name               = "SYSTEM_BFD_v01"
#   feature_profile_id = sdwan_system_feature_profile.system_v01.id
# }

# resource "sdwan_system_global_feature" "system_global_v01" {
#   name               = "SYSTEM_GLOBAL_v01"
#   feature_profile_id = sdwan_system_feature_profile.system_01.id
# }

# resource "sdwan_system_logging_feature" "system_logging_v01" {
#   name               = "SYSTEM_LOGGING_v01"
#   feature_profile_id = sdwan_system_feature_profile.system_01.id
# }

resource "sdwan_transport_wan_vpn_feature" "transport_wan_vpn_01" {
  name               = "TRANSPORT_WAN_VPN0_v01"
  feature_profile_id = sdwan_transport_feature_profile.transport_v01.id
  vpn                = 0
  primary_dns_address_ipv4   = "8.8.8.8"
  secondary_dns_address_ipv4 = "1.1.1.1"
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
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.transport_wan_vpn_01.id
  interface_name               = "GigabitEthernet1"
  shutdown                     = false
  interface_description        = "WAN"
  ipv4_configuration_type      = "static"
  ipv4_address                 = "172.16.10.2"
  ipv4_subnet_mask             = "255.255.255.252"
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
  # devices = [{
  #   id     = "C8K-40C0CCFD-9EA8-2B2E-E73B-32C5924EC79B"
  #   deploy = true
  #   variables = [
  #     {
  #       name = "host_name"
  #       value = "edge1"
  #     },
  #     {
  #       name = "pseudo_commit_timer"
  #       value = 0
  #     },
  #     {
  #       name = "site_id"
  #       value = 1
  #     },
  #     {
  #       name = "system_ip"
  #       value = "10.1.1.1"
  #     },
  #     {
  #       name = "ipv6_strict_control"
  #       value = "false"
  #     }
  #   ]
  # }]
  feature_versions = [
    sdwan_system_basic_feature.system_01_basic.version,
    sdwan_system_aaa_feature.system_01_aaa.version,
    # sdwan_system_bfd_feature.system_bfd_v01.version,
    # sdwan_system_global_feature.system_global_v01.version,
    # sdwan_system_logging_feature.system_logging_v01.version,
    sdwan_system_omp_feature.system_01_omp.version,
    sdwan_transport_wan_vpn_feature.transport_wan_vpn_v01.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.transport_wan_vpn_if_eth_v01.version,
  ]
}








resource "sdwan_system_basic_feature" "system_01_basic" {
  name               = "system_01_basic"
  feature_profile_id = sdwan_system_feature_profile.system_01.id
}

resource "sdwan_system_aaa_feature" "system_01_aaa" {
  name               = "system_01_aaa"
  feature_profile_id = sdwan_system_feature_profile.system_01.id
  server_auth_order  = ["local"]
  users = [{
    name     = "admin"
    password = "admin"
  }]
}

# resource "sdwan_system_bfd_feature" "system_01_bfd" {
#   name               = "system_01_bfd"
#   feature_profile_id = sdwan_system_feature_profile.system_01.id
# }

resource "sdwan_system_global_feature" "system_01_global" {
  name               = "system_01_global"
  feature_profile_id = sdwan_system_feature_profile.system_01.id
}

resource "sdwan_system_logging_feature" "system_01_logging" {
  name               = "system_01_logging"
  feature_profile_id = sdwan_system_feature_profile.system_01.id
}

resource "sdwan_system_omp_feature" "system_01_omp" {
  name               = "system_01_omp"
  feature_profile_id = sdwan_system_feature_profile.system_01.id
}

resource "sdwan_transport_wan_vpn_feature" "transport_01_wan_vpn" {
  name               = "transport_01_wan_vpn"
  feature_profile_id = sdwan_transport_feature_profile.transport_01.id
  vpn                = 0
}

resource "sdwan_transport_wan_vpn_interface_ethernet_feature" "transport_01_wan_vpn_interface_ethernet" {
  name                         = "transport_01_wan_vpn_interface_ethernet"
  feature_profile_id           = sdwan_transport_feature_profile.transport_01.id
  transport_wan_vpn_feature_id = sdwan_transport_wan_vpn_feature.transport_01_wan_vpn.id
  interface_name               = "GigabitEthernet1"
  shutdown                     = false
  interface_description        = "WAN"
  ipv4_configuration_type      = "static"
  ipv4_address                 = "1.2.3.4"
  ipv4_subnet_mask             = "0.0.0.0"
  tunnel_interface_encapsulations = [
    {
      encapsulation = "ipsec"
    }
  ]
}

# CONFIGURATION GROUP:
resource "sdwan_configuration_group" "config_group_01" {
  name        = "config_group_01"
  description = "My config group"
  solution     = "sdwan"
  feature_profile_ids = [sdwan_system_feature_profile.system_01.id, sdwan_transport_feature_profile.transport_01.id]
  # devices = [{
  #   id     = "C8K-40C0CCFD-9EA8-2B2E-E73B-32C5924EC79B"
  #   deploy = true
  #   variables = [
  #     {
  #       name = "host_name"
  #       value = "edge1"
  #     },
  #     {
  #       name = "pseudo_commit_timer"
  #       value = 0
  #     },
  #     {
  #       name = "site_id"
  #       value = 1
  #     },
  #     {
  #       name = "system_ip"
  #       value = "10.1.1.1"
  #     },
  #     {
  #       name = "ipv6_strict_control"
  #       value = "false"
  #     }
  #   ]
  # }]
  feature_versions = [
    sdwan_system_basic_feature.system_01_basic.version,
    sdwan_system_aaa_feature.system_01_aaa.version,
    # sdwan_system_bfd_feature.system_01_bfd.version,
    sdwan_system_global_feature.system_01_global.version,
    sdwan_system_logging_feature.system_01_logging.version,
    sdwan_system_omp_feature.system_01_omp.version,
    sdwan_transport_wan_vpn_feature.transport_01_wan_vpn.version,
    sdwan_transport_wan_vpn_interface_ethernet_feature.transport_01_wan_vpn_interface_ethernet.version,
  ]
}