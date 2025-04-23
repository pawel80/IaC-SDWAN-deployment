# CONFIGURATION GROUP:
resource "sdwan_configuration_group" "config_group_v01" {
  name        = "CG_SDR_SINGLE_v01"
  description = "My config group"
  solution     = "sdwan"
  feature_profile_ids = [sdwan_system_feature_profile.system_v01.id, sdwan_transport_feature_profile.transport_v01.id]
  devices = [
    # {
    # id     = "C8K-0004C57D-A2B1-4D3D-8F7A-ABA9D3AF1D8D"
    # deploy = true
    # variables = [
    #   {
    #     name = "host_name"
    #     value = "S1R1"
    #   },
    #   {
    #     name = "pseudo_commit_timer"
    #     value = 0
    #   },
    #   {
    #     name = "site_id"
    #     value = 101
    #   },
    #   {
    #     name = "system_ip"
    #     value = "11.1.1.1"
    #   },
    #   {
    #     name = "ipv6_strict_control"
    #     value = "false"
    #   },
    #   {
    #     name = "var_def_gtw"
    #     value = "172.16.10.1"
    #   },
    #   {
    #     name = "var_vpn0_if_address"
    #     value = "172.16.10.2"
    #   },
    #   {
    #     name = "var_vpn0_if_mask"
    #     value = "255.255.255.252"
    #   }
    #   # {
    #   #   name = "var_dns_secondary"
    #   #   value = "1.2.3.4"
    #   # }
    #   # {
    #   #   name = "var_tunnel_netconf"
    #   #   value = true
    #   # }
    #   ]
    # },
    # {
    # id     = "C8K-55121EB3-198F-3F17-2F1C-5D73078DBEE0"
    # deploy = true
    # variables = [
    #   {
    #     name = "host_name"
    #     value = "S2R1"
    #   },
    #   {
    #     name = "pseudo_commit_timer"
    #     value = 0
    #   },
    #   {
    #     name = "site_id"
    #     value = 102
    #   },
    #   {
    #     name = "system_ip"
    #     value = "11.1.2.1"
    #   },
    #   {
    #     name = "ipv6_strict_control"
    #     value = "false"
    #   },
    #   {
    #     name = "var_def_gtw"
    #     value = "172.16.10.9"
    #   },
    #   {
    #     name = "var_vpn0_if_address"
    #     value = "172.16.10.10"
    #   },
    #   {
    #     name = "var_vpn0_if_mask"
    #     value = "255.255.255.252"
    #   }
    #   ]
    # }
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