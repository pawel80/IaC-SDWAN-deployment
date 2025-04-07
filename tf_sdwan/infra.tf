# FEATURE PROFILES:
resource "sdwan_system_feature_profile" "system_01" {
  name        = "system_01"
  description = "My system feature profile"
}

resource "sdwan_transport_feature_profile" "transport_01" {
  name        = "transport_01"
  description = "My transport feature profile"
}

# FEATURES (for FEATURE PROFILES):
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

resource "sdwan_system_bfd_feature" "system_01_bfd" {
  name               = "system_01_bfd"
  feature_profile_id = sdwan_system_feature_profile.system_01.id
}

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
  ipv4_dhcp_distance           = 1
  tunnel_interface             = true
  tunnel_interface_encapsulations = [
    {
      encapsulation = "ipsec"
    }
  ]
}