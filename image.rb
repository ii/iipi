require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'
#require 'chef/provider/hanlon_image'
#require 'chef/resource/hanlon_image'
require 'pry'
with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

hanlon_image 'Hanlon Microkernel 2.0.1' do
  #action :delete
  type 'mk'
  path 'hnl_mk_debug-image.2.0.1.iso'
  version '2.0.1'
  description 'Hanlon Image'
end

hanlon_image 'CoreOS' do
  #action :delete
  type 'os'
  path 'coreos_production_iso_image.iso'
  version '556'
  description 'Coreos stable'
end

hanlon_image 'Centos6' do
  #action :delete
  type 'os'
  path 'CentOS-6.6-x86_64-minimal.iso'
  version '6.6'
  description 'Centos 6'
end
