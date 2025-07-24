resource "sdwan_system_feature_profile" "controller1_system_v01" {
  name        = "CONTROLLER1_SYSTEM_v01"
  description = "CONTROLLER1 System settings"
}

resource "sdwan_cli_feature_profile" "controller1_cli_v01" {
  name        = "CONTROLLER1_CLI_FEATURE_PROFILE_v01"
  description = "CONTROLLER1 CLI Feature Profile"
}

resource "sdwan_system_basic_feature" "controller1_system_basic_v01" {
  name               = "CONTROLLER1_SYSTEM_BASIC_v01"
  feature_profile_id = sdwan_system_feature_profile.controller1_system_v01.id
  controller_groups  = [1]
}

resource "sdwan_system_global_feature" "controller1_system_global_v01" {
  name               = "CONTROLLER1_SYSTEM_GLOBAL_v01"
  feature_profile_id = sdwan_system_feature_profile.controller1_system_v01.id
}

resource "sdwan_cli_config_feature" "controller1_cli_cfg_v01" {
  feature_profile_id = sdwan_cli_feature_profile.controller1_cli_v01.id
  name               = "CONTROLLER1_CLI_CFG_v01"
  description        = "CONTROLLER1 CLI config"
  cli_configuration  = <<-EOT
system                                                                                                                                                                                                                                             
!  host-name             SDWAN-Controller                                                                                                                                                                                                            
!  system-ip             10.99.1.3                                                                                                                                                                                                                   
!  site-id               9000                                                                                                                                                                                                                        
!  admin-tech-on-failure                                                                                                                                                                                                                             
!  no vrrp-advt-with-phymac                                                                                                                                                                                                                          
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

resource "sdwan_configuration_group" "controller1_config_group_v01" {
  name        = "CG_CONTROLLER_v01"
  description = "Configuration group - Controllers"
  solution     = "sdwan"
  feature_profile_ids = [
    sdwan_system_feature_profile.controller1_system_v01.id, 
    sdwan_cli_feature_profile.controller1_cli_v01.id,
  ]
  devices = local.controllers
  feature_versions = [
    sdwan_system_basic_feature.controller1_system_basic_v01.version,
    sdwan_system_global_feature.controller1_system_global_v01.version,
    sdwan_cli_config_feature.controller1_cli_cfg_v01.version,
  ]
}