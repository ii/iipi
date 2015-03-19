require 'chef/provisioning'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

# TODO: write a hanlon_image resource, to upload ISOs
# TODO: write a hanlon_tag resources, to match machines to tags
# for now just used node_uuid for the tag and pass node_uuid
# into the machine_options so we can retrieve the active_model

# hanlon node 3IssihVuBEAgTVO7Zi22SO
#Node:
# UUID =>  3IssihVuBEAgTVO7Zi22SO
# Last Checkin =>  03-18-15 16:52:21
# Status =>  active
# Tags =>  [C,cpus_6,Supermicro,nics_2]
# Hardware IDs =>  [00000000-0000-0000-0000-002590E252B8]

with_machine_options node_uuid: '00000000-0000-0000-0000-002590E252B8',

# $ hanlon image
# Images:
#          UUID                 Type                Name/Filename          Status  
# 7BWtJSCYZbL0vqNsm4l2Xg  OS Install         centos6                       Valid  
# 692Vjhns2hc7hvYGLavlUW  OS Install         coreos557                     Valid  
# 4RSLIKBj819WTMPpzrlNTU  MicroKernel Image  hnl_mk_debug-image.2.0.1.iso  Valid  

                     image_uuid: '692Vjhns2hc7hvYGLavlUW',
                     
# hanlon model 6arWglQXS1zniJ8tS2G8CG -h
#Model:
# Label =>  Deploying Coreos
# Template =>  linux_deploy
# Description =>  coreos stable
# UUID =>  6arWglQXS1zniJ8tS2G8CG
# Image UUID =>  692Vjhns2hc7hvYGLavlUW
                     
                     model: {
#     Template Name                     Description                 
# boot_local              Noop model to add existing nodes          
# centos_6                CentOS 6 Model                            
# coreos_stable           coreos stable                             
# debian_wheezy           Debian Wheezy Model                       
# discover_only           Noop model to discover new nodes          
# opensuse_12             OpenSuSE Suse 12 Model                    
# oraclelinux_6           Oracle Linux 6 Model                      
# redhat_6                RedHat 6 Model                            
# redhat_7                RedHat 7 Model                            
# sles_11                 SLES 11 Model                             
# ubuntu_oneiric          Ubuntu Oneiric Model                      
# ubuntu_precise          Ubuntu Precise Model                      
# ubuntu_precise_ip_pool  Ubuntu Precise Model (IP Pool)            
# vmware_esxi_5           VMware ESXi 5 Deployment                  
# windows_2012_r2         Windows 2012 R2                           
# xenserver_boston        Citrix XenServer 6.0 (boston) Deployment  
# xenserver_tampa         Citrix XenServer 6.1 (tampa) Deployment   
                       template: 'coreos_stable',

# I'm not sure how to pull out the req_attributes via rest or hanlon command line yet
                       hostname_prefix: 'pii',
                       domainname: 'instantinfrastructure.com',
                       root_password: 'test1234',
                       label: 'Deploying Coreos',
                     },


# $ hanlon policy                     
#Policies:
##  Enabled       Label        Tags    Model Label     #/Max  Counter           UUID           
#1  true     iicoreos - mario  [A]   Deploying Coreos  0/1    0        6byIGJJwppb9DNfAPRSoIa  

                       

                     policy: {
#      Template                            Description                       
# boot_local            Policy used to adding existing nodes to Hanlon.       
# discover_only         Policy used to discover new nodes.                    
# linux_deploy          Policy for deploying a Linux-based operating system.  
# vmware_hypervisor     Policy for deploying a VMware hypervisor.             
# windows_deploy        Policy for deploying a Windows operating system.      
# xenserver_hypervisor  Policy for deploying a XenServer hypervisor.
                       template: 'linux_deploy',

# Label prefix is prepended to the nodename, the policy is for one node only
# which gives us a label of "#{label} - #{nodename}"
                       
                       label_prefix: 'iicoreos',

                       
# Tags help us choose which servers to allocate from, we need matchers for this
# for now let's used the hw_id
# $ hanlon active_model --hw_id 00000000-0000-0000-0000-00259097D478 | grep Node\ UUID
# Node UUID =>  2i1j2aUlWWMS0NdkwBA6W0
# $ hanlon node 2i1j2aUlWWMS0NdkwBA6W0 -f attributes | grep 'ipaddress_eth0'
# ipaddress_eth0                        1.1.1.1                        
                       tags: '00000000-0000-0000-0000-002590E252B8',
                     }

# for now let's use a tag of the node_uuid or hw_id
machine 'luigi' do
  action :setup
  tag 'itsa_me'
  converge false
end
