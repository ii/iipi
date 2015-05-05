require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'
require 'pry'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

num = ENV['HARDWARE_TARGET'] || '1'
deploy="coreos_inmem_on_#{num}"

hanlon_image 'coreos_production_iso_image.iso' do
  type 'os'
  version '556'
  description 'CoreOS stable 556'
end

hanlon_model "#{deploy}" do
  action :delete if ENV['DESTROY']
  image 'coreos_production_iso_image.iso'
  template 'coreos_in_memory'
  metadata ({
              hostname_prefix: 'iicoreos',
              domainname: 'vulk.can.cd',
              cloud_config: {
                users: [{ name: 'hh','coreos-ssh-import-github' =>  'hh',
                          groups: [ 'sudo', 'docker']}],
                coreos: { units: [
                            { name: 'etcd.service', command: 'start' },
                            { name: 'fleet.service', command: 'start' },
                          ]},} })
end

hanlon_policy "#{deploy}" do
  model "#{deploy}"
  template 'linux_deploy'
  tags num
  maximum 1
end

execute "ipmi-chassis -h 1.1.0.#{num} --chassis-control=power-up"
