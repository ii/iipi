require 'chef/provisioning'
with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

# see https://github.com/csc/Hanlon/pull/329
ubuntu_opts = {
  root_password: 'testing123',
  hostname_prefix: 'pii',
  domainname: 'instantinfrastructure.com',
}

image = hanlon_image 'Ubuntu 12.04.4' do
  action :nothing
  type 'os'
  path 'ubuntu-12.04.4-server-amd64.iso'
  version '12.04.4'
  description 'Ubuntu 12.04.4'
end
image.run_action :create
image_uuid = image.provider_for_action(:create).load_current_resource.uuid

#model
model = 'ubuntu_precise'

num=3
with_machine_options(
  image: {
    uuid: image_uuid,
  },
  model: {
    label: "chef+#{model}",
    template: 'ubuntu_precise',
    req_metadata_params: ubuntu_opts
  },
  policy: {
    label_prefix: "iiubuntu-#{num}",
    template: 'linux_deploy',
    # for now let's use the automatic hw_id tag
    tags: [ num ].join(',')
  }
)
  
machine 'ubuntutest' do
  action :setup
  tag "ubuntu"
  converge false
end
