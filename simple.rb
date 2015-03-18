require 'chef/provisioning'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

# TODO: write a hanlon_image resource, to upload ISOs
# TODO: write a hanlon_tag resources, to match machines to tags
# for now just setthe image_uuid and policy.tags manually
with_machine_options image_uuid: '692Vjhns2hc7hvYGLavlUW',
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
                       hostname_prefix: 'pii',
                       domainname: 'instantinfrastructure.com',
                       root_password: 'test1234',
                       label: 'test_label_XYZ',
                     },
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
                       label_prefix: 'ii',
# Tags help us choose which servers to allocate from, we need matchers for this
                       tags: 'A',
                     }

machine 'mario' do
  action :setup
  tag 'itsa_me'
  converge false
end
