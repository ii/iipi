require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

num = ENV['HARDWARE_TARGET'] || '3'
deploy="centos_on_#{num}"

hanlon_image 'CentOS-6.6-x86_64-minimal.iso' do
  type 'os'
  version '6.6'
  description 'Centos 6'
end

hanlon_model "#{deploy}" do
  action :delete if ENV['DESTROY']
  image 'CentOS-6.6-x86_64-minimal.iso'
  template 'centos_6'
  metadata ({
              hostname_prefix: 'iicentos',
              domainname: 'vulk.can.cd',
              root_password: 'testing123',
            })
end

hanlon_policy "#{deploy}" do
  model "#{deploy}"
  template 'linux_deploy'
  tags num
  maximum 1
end

execute "ipmi-chassis -h 1.1.0.#{num} --chassis-control=power-up"
