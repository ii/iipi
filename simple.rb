require 'chef/provisioning'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

# see https://github.com/csc/Hanlon/pull/329
centos6_opts = {
  root_password: 'testing123',
}

with_machine_options(
  image_uuid: '692Vjhns2hc7hvYGLavlUW',
  model: {
    label: 'Deploying Coreos',
    template: 'coreos_stable',
    req_metadata_hash: {
      hostname_prefix: 'pii',
      domainname: 'instantinfrastructure.com',
    }.merge(coreos_opts),
  }
  policy: {
    label_prefix: 'iicoreos',
    template: 'linux_deploy',
    # for now let's use the automatic hw_id tag
    tags: '00000000-0000-0000-0000-002590E252B8',
  }
)
  
machine 'number2' do
  action :setup
  tag "coreos!"
  converge false
end
