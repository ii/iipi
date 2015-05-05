require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

num = ENV['HARDWARE_TARGET'] || '4'
deploy="esxi_on_#{num}"

hanlon_image 'VMware-VMvisor-Installer-6.0.0-2494585.x86_64.iso' do
  type 'esxi'
  version '6.0.0'
  description 'VMWare esxi 6'
end

hanlon_model "#{deploy}" do
  action :delete if ENV['DESTROY']
  image 'VMware-VMvisor-Installer-6.0.0-2494585.x86_64.iso'
  template 'vmware_esxi_5'
  metadata ({
              esx_license: 'N060J-4UL8H-J8281-0V9K2-3E9N5',
              hostname_prefix: 'iiesx',
              root_password: 'testing123',
              ip_range_network: '1.1.1',
              ip_range_subnet: '255.255.255.0',
              ip_range_start: "1#{num}0",
              ip_range_end: "1#{num}9",
              gateway: '1.1.1.111',
              nameserver: '8.8.8.8',
              ntpserver: 'time.apple.com',
            })
end

hanlon_policy "#{deploy}" do
  model "#{deploy}"
  template 'vmware_hypervisor'
  tags num
  maximum 1
end

bash "ipmi-chassis -h 1.1.0.#{num} --chassis-control=power-up"
