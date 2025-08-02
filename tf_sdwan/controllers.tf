###################################################################################
############################### SD-WAN Controllers ################################
###################################################################################

#--------------------------------- Feature Templates ------------------------------
resource "sdwan_cisco_system_feature_template" "controller_system_v1" {
  name               = "CONTROLLER_SYSTEM_v01"
  description        = "Controller System v1"
  device_types       = ["vsmart"]
}

resource "sdwan_cisco_vpn_feature_template" "controller_transport_v1" {
  name                    = "CONTROLLER_TRANSPORT_v01"
  description             = "Controller Transport v1"
  device_types            = ["vsmart"]
  vpn_id                  = 0
  vpn_name                = "TRANSPORT"
  dns_ipv4_servers = [
    {
      address = "8.8.8.8"
      role    = "primary"
    },
    {
      address = "1.1.1.1"
      role    = "secondary"
    }
  ]
  ipv4_static_routes = [
    {
      prefix   = "0.0.0.0/0"
      vpn_id   = 0
      next_hops = [
        {
          address  = "172.16.9.254"
        }
      ]
    }
  ]
}

resource "sdwan_cisco_vpn_interface_feature_template" "controller_eth1_v1" {
  name                  = "CONTROLLER_ETH1_v01"
  description           = "Controller WAN eth1 interface v1"
  device_types          = ["vsmart"]
  interface_name        = "eth1"
  interface_description = "WAN"
  address               = "172.16.9.3/24"
  tunnel_interface_encapsulations = [
    {
      encapsulation = "gre"
    }
  ]
  tunnel_interface_allow_all                     = false
  tunnel_interface_allow_bgp                     = false
  tunnel_interface_allow_dhcp                    = false
  tunnel_interface_allow_dns                     = true
  tunnel_interface_allow_icmp                    = true
  tunnel_interface_allow_ssh                     = false
  tunnel_interface_allow_netconf                 = false
  tunnel_interface_allow_ntp                     = false
  tunnel_interface_allow_ospf                    = false
  tunnel_interface_allow_stun                    = false
  tunnel_interface_allow_snmp                    = false
  tunnel_interface_allow_https                   = false
}

#---------------------------------- Device Template -------------------------------
resource "sdwan_feature_device_template" "controller_device_temp_v1" {
  name        = "DT_CONTROLLER_v01"
  description = "Template for Controllers v1"
  device_type = "vsmart"
  general_templates = [
    {
      id   = sdwan_cisco_system_feature_template.controller_system_v1.id
      type = "cisco_system"
    },
    {
      id   = sdwan_cisco_vpn_feature_template.controller_transport_v1.id
      type = "cisco_vpn"
    },
    {
      id   = sdwan_cisco_vpn_interface_feature_template.controller_eth1_v1.id
      type = "cisco_vpn"
    }
  ]
}

resource "sdwan_cli_device_template" "controller_cli_v1" {
  name              = "DT_CLI_CONTROLLER_v01"
  description       = "CLI Template for Controllers v1"
  device_type       = "vsmart"
  cli_type          = "intend"
  cli_configuration  = <<-EOT
system
  host-name             SDWAN-CTR1                                                                                                                                                                                                           
  system-ip             10.99.1.3                                                                                                                                                                                                                   
  site-id               9000                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  admin-tech-on-failure                                                                                                                                                                                                                             
  no vrrp-advt-with-phymac                                                                                                                                                                                                                          
  organization-name     "network-lab-sdwan - 401109"                                                                                                                                                                                                
  vbond 172.16.9.1                                                                                                                                                                                                                                  
 aaa                                                                                                                                                                                                                                               
  auth-order      local radius tacacs                                                                                                                                                                                                              
  usergroup basic                                                                                                                                                                                                                                  
   task system read                                                                                                                                                                                                                                
   task interface read                                                                                                                                                                                                                             
  !                                                                                                                                                                                                                                                
  usergroup netadmin                                                                                                                                                                                                                               
  !                                                                                                                                                                                                                                                
  usergroup operator                                                                                                                                                                                                                               
   task system read                                                                                                                                                                                                                                
   task interface read                                                                                                                                                                                                                             
   task policy read                                                                                                                                                                                                                                
   task routing read                                                                                                                                                                                                                               
   task security read                                                                                                                                                                                                                              
  !                                                                                                                                                                                                                                                
  usergroup tenantadmin                                                                                                                                                                                                                            
  !                                                                                                                                                                                                                                                
  user admin                                                                                                                                                                                                                                       
   password $6$b3ca36642bb3523d$VoHcuMu0gBk1s3AWbVu.WgW.v.7bXKDuD5zZP2qPSJmbfBiRValt0I4U8kjAEJi1FgRnKpNgd7bzIrHslVU3H0                                                                                                                             
  !                                                                                                                                                                                                                                                
  ciscotacro-user true                                                                                                                                                                                                                             
  ciscotacrw-user true                                                                                                                                                                                                                             
 !                                                                                                                                                                                                                                                 
 logging                                                                                                                                                                                                                                           
  disk                                                                                                                                                                                                                                             
   enable                                                                                                                                                                                                                                          
  !                                                                                                                                                                                                                                                
 !                                                                                                                                                                                                                                                 
 ntp                                                                                                                                                                                                                                               
  parent                                                                                                                                                                                                                                           
   no enable                                                                                                                                                                                                                                       
   stratum 5                                                                                                                                                                                                                                       
  exit                                                                                                                                                                                                                                             
 !                                                                                                                                                                                                                                                 
!                                                                                                                                                                                                                                                  
omp                                                                                                                                                                                                                                                
 no shutdown                                                                                                                                                                                                                                       
 send-path-limit         6                                                                                                                                                                                                                     
 filter-route                                                                                                                                                                                                                                      
  no outbound affinity-group-preference                                                                                                                                                                                                            
  no outbound tloc-color                                                                                                                                                                                                                           
 exit                                                                                                                                                                                                                                              
 graceful-restart
 outbound-policy-caching                                                                                                                                                                                                                           
!                                                                                                                                                                                                                                                  
vpn 0                                                                                                                                                                                                                                              
 interface eth1                                                                                                                                                                                                                                    
  ip address 172.16.9.3/24                                                                                                                                                                                                                         
  tunnel-interface                                                                                                                                                                                                                                 
   allow-service dhcp                                                                                                                                                                                                                              
   allow-service dns                                                                                                                                                                                                                               
   allow-service icmp                                                                                                                                                                                                                              
   no allow-service sshd                                                                                                                                                                                                                           
   no allow-service netconf                                                                                                                                                                                                                        
   no allow-service ntp                                                                                                                                                                                                                            
   no allow-service stun                                                                                                                                                                                                                           
  !                                                                                                                                                                                                                                                
  no shutdown                                                                                                                                                                                                                                      
 !                                                                                                                                                                                                                                                 
 ip route 0.0.0.0/0 172.16.9.254                                                                                                                                                                                                                   
!                                                                                                                                                                                                                                                  
vpn 512                                                                                                                                                                                                                                            
!
  EOT
}

# resource "sdwan_attach_feature_device_template" "controller_attached_v1" {
#   # id = sdwan_cli_device_template.controller_cli_v1.id
#   id = sdwan_feature_device_template.controller_device_temp_v1.id
#   devices = local.controllers
# }



#-------------------------------- Configuration Group -----------------------------
resource "sdwan_system_feature_profile" "controller1_system_v01" {
  name        = "CONTROLLER1_SYSTEM_v01"
  description = "CONTROLLER1 System settings"
}

resource "sdwan_cli_feature_profile" "controller1_cli_v01" {
  name        = "CONTROLLER1_CLI_FEATURE_PROFILE_v01"
  description = "CONTROLLER1 CLI Feature Profile"
}

resource "sdwan_cli_config_feature" "controller1_cli_cfg_v01" {
  feature_profile_id = sdwan_cli_feature_profile.controller1_cli_v01.id
  name               = "CONTROLLER1_CLI_CFG_v01"
  description        = "CONTROLLER1 CLI config"
  cli_configuration  = <<-EOT
system                                                                                                                                                                                                                                             
  host-name             SDWAN-CTR1                                                                                                                                                                                                           
  system-ip             10.99.1.3                                                                                                                                                                                                                   
  site-id               9000                                                                                                                                                                                                                        
  admin-tech-on-failure                                                                                                                                                                                                                             
  no vrrp-advt-with-phymac                                                                                                                                                                                                                          
  organization-name     "network-lab-sdwan - 401109"                                                                                                                                                                                                
  vbond 172.16.9.1                                                                                                                                                                                                                                  
 aaa                                                                                                                                                                                                                                               
  auth-order      local radius tacacs                                                                                                                                                                                                              
  usergroup basic                                                                                                                                                                                                                                  
   task system read                                                                                                                                                                                                                                
   task interface read                                                                                                                                                                                                                             
  !                                                                                                                                                                                                                                                
  usergroup netadmin                                                                                                                                                                                                                               
  !                                                                                                                                                                                                                                                
  usergroup operator                                                                                                                                                                                                                               
   task system read                                                                                                                                                                                                                                
   task interface read                                                                                                                                                                                                                             
   task policy read                                                                                                                                                                                                                                
   task routing read                                                                                                                                                                                                                               
   task security read                                                                                                                                                                                                                              
  !                                                                                                                                                                                                                                                
  usergroup tenantadmin                                                                                                                                                                                                                            
  !                                                                                                                                                                                                                                                
  user admin                                                                                                                                                                                                                                       
   password $6$b3ca36642bb3523d$VoHcuMu0gBk1s3AWbVu.WgW.v.7bXKDuD5zZP2qPSJmbfBiRValt0I4U8kjAEJi1FgRnKpNgd7bzIrHslVU3H0                                                                                                                             
  !                                                                                                                                                                                                                                                
  ciscotacro-user true                                                                                                                                                                                                                             
  ciscotacrw-user true                                                                                                                                                                                                                             
 !                                                                                                                                                                                                                                                 
 logging                                                                                                                                                                                                                                           
  disk                                                                                                                                                                                                                                             
   enable                                                                                                                                                                                                                                          
  !                                                                                                                                                                                                                                                
 !                                                                                                                                                                                                                                                 
 ntp                                                                                                                                                                                                                                               
  parent                                                                                                                                                                                                                                           
   no enable                                                                                                                                                                                                                                       
   stratum 5                                                                                                                                                                                                                                       
  exit                                                                                                                                                                                                                                             
 !                                                                                                                                                                                                                                                 
!                                                                                                                                                                                                                                                  
omp                                                                                                                                                                                                                                                
 no shutdown                                                                                                                                                                                                                                       
 send-path-limit         6                                                                                                                                                                                                                     
 filter-route                                                                                                                                                                                                                                      
  no outbound affinity-group-preference                                                                                                                                                                                                            
  no outbound tloc-color                                                                                                                                                                                                                           
 exit                                                                                                                                                                                                                                              
 graceful-restart
 outbound-policy-caching                                                                                                                                                                                                                           
!                                                                                                                                                                                                                                                  
vpn 0                                                                                                                                                                                                                                              
 interface eth1                                                                                                                                                                                                                                    
  ip address 172.16.9.3/24                                                                                                                                                                                                                         
  tunnel-interface                                                                                                                                                                                                                                 
   allow-service dhcp                                                                                                                                                                                                                              
   allow-service dns                                                                                                                                                                                                                               
   allow-service icmp                                                                                                                                                                                                                              
   no allow-service sshd                                                                                                                                                                                                                           
   no allow-service netconf                                                                                                                                                                                                                        
   no allow-service ntp                                                                                                                                                                                                                            
   no allow-service stun                                                                                                                                                                                                                           
  !                                                                                                                                                                                                                                                
  no shutdown                                                                                                                                                                                                                                      
 !                                                                                                                                                                                                                                                 
 ip route 0.0.0.0/0 172.16.9.254                                                                                                                                                                                                                   
!                                                                                                                                                                                                                                                  
vpn 512                                                                                                                                                                                                                                            
!
  EOT
}

# resource "sdwan_configuration_group" "controller1_config_group_v01" {
#   name        = "CG_CONTROLLER_v01"
#   description = "Configuration group - Controllers"
#   solution     = "sdwan"
#   feature_profile_ids = [
#     sdwan_system_feature_profile.controller1_system_v01.id, 
#     sdwan_cli_feature_profile.controller1_cli_v01.id,
#   ]
#   devices = local.controllers
#   feature_versions = [
#     sdwan_cli_config_feature.controller1_cli_cfg_v01.version,
#   ]
# }
