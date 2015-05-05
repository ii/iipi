require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

hanlon_image 'hnl_mk_debug-image.2.0.1.iso' do
  type 'mk'
  version '2.0.1'
  description 'MicroKernel Image'
end

hanlon_image 'coreos_production_iso_image.iso' do
  type 'os'
  version '556'
  description 'CoreOS stable 556'
end

hanlon_image 'CentOS-6.6-x86_64-minimal.iso' do
  type 'os'
  version '6.6'
  description 'Centos 6'
end

hanlon_image 'VMware-VMvisor-Installer-6.0.0-2494585.x86_64.iso' do
  type 'esxi'
  version '6.0.0'
  description 'VMWare esxi 6'
end


# hanlon_image 'Ubuntu 12.04.4' do
#   #action :delete
#   type 'os'
#   path 'ubuntu-12.04.4-server-amd64.iso'
#   version '12.04.4'
#   description 'Ubuntu 12.04.4'
# end

#hanlon_image 'ubuntu-14.04.2-server-amd64.iso' do
#  type 'os'
#  path 'ubuntu-14.04.2-server-amd64.iso'
#  version '14.04.2'
#  description 'Ubuntu 14.04.2'
#end

