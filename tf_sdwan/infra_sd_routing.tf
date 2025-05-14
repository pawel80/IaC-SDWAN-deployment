
# FOR SD-ROUTING, I will need a higher software version 17.13 and 20.13 ?

# CONFIGURATION GROUP:
# resource "sdwan_configuration_group" "config_group_sdr_v01" {
#   name        = "CG_SDR_SINGLE_v01"
#   description = "My config group"
#   solution     = "sdwan"
#   feature_profile_ids = [sdwan_system_feature_profile.system_v01.id, sdwan_transport_feature_profile.transport_v01.id]
#   devices = [
#     {
#     id     = "C8K-D4DEEFAA-9C5F-7320-FCCA-E72E4DCCBBD4"
#     deploy = true
#     variables = [
#       {
#         name = "host_name"
#         value = "S5R1"
#       },
#       {
#         name = "pseudo_commit_timer"
#         value = 0
#       },
#       {
#         name = "site_id"
#         value = 205
#       },
#       {
#         name = "system_ip"
#         value = "22.3.5.1"
#       },
#       {
#         name = "ipv6_strict_control"
#         value = "false"
#       },
#       {
#         name = "var_def_gtw"
#         value = "172.16.10.25"
#       },
#       {
#         name = "var_vpn0_if_address"
#         value = "172.16.10.26"
#       },
#       {
#         name = "var_vpn0_if_mask"
#         value = "255.255.255.252"
#       }
#       ]
#     },
#     {
#     id     = "C8K-FA901F6C-967C-0F62-26F1-901FE43B804D"
#     deploy = true
#     variables = [
#       {
#         name = "host_name"
#         value = "S6R1"
#       },
#       {
#         name = "pseudo_commit_timer"
#         value = 0
#       },
#       {
#         name = "site_id"
#         value = 206
#       },
#       {
#         name = "system_ip"
#         value = "22.3.6.1"
#       },
#       {
#         name = "ipv6_strict_control"
#         value = "false"
#       },
#       {
#         name = "var_def_gtw"
#         value = "172.16.10.29"
#       },
#       {
#         name = "var_vpn0_if_address"
#         value = "172.16.10.30"
#       },
#       {
#         name = "var_vpn0_if_mask"
#         value = "255.255.255.252"
#       }
#       ]
#     }
#   ]
#   feature_versions = [
#     sdwan_system_basic_feature.system_basic_v01.version,
#     sdwan_system_aaa_feature.system_aaa_v01.version,
#     # sdwan_system_bfd_feature.system_bfd_v01.version,
#     sdwan_system_global_feature.system_global_v01.version,
#     # sdwan_system_logging_feature.system_logging_v01.version,
#     sdwan_system_omp_feature.system_omp_v01.version,
#     sdwan_transport_wan_vpn_feature.transport_wan_vpn_v01.version,
#     sdwan_transport_wan_vpn_interface_ethernet_feature.transport_wan_vpn_if_eth_v01.version,
#   ]
# }