require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'

with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

# see https://github.com/csc/Hanlon/pull/329
coreos_opts = {
  install_disk: '/dev/sda',
  cloud_config: {
    coreos: {
      units: [
        {
          name: 'etcd.service',
          command: 'start'
        },
        {
          name: 'fleet.service',
          command: 'start'
        },
      ]
    },
    ssh_authorized_keys:
      [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAsUXHYuDzE6fs2KkCj91qSqpMXyxozb9gDKcx3mlh87hCegevld75gQAhujVYGRgJLsdf7W0/lX81clCRP1FjbaYYrPkVWGR291U6K5rkL9kZqd9dC0h9iCvFTKdKC7sA/uaolFPWav3QFWdEp3geNNuAm/NKSckUs9yGgr1inANQNsHFl0JFzU34D2Kt43rKA0Qz3kkDKCnXzl+wltIKq5f1SH1HDlv0hoLgikVwg5CLLKCsZ8IFuxur1pdb26uM0vtFp2LJUNad6hK8RsU6p/NeTtOLjbKGsLkqCgSvoPxCAIbFKWIRuAfGd6CrNc2kAD4qM45jAvI9dLuzbopVfhXS16F0i3EzL8/VWuCk7l2mYRdjHAy+9fJksx1zx2wfeEXSoSUX8/ROxpWZaDA8gLAxUrp/hqHU351QDDEdunMfmlrGc6ixyIaxMugRuNsNB4eY91mmbiljeoSCs1GFbVRhC8KejdKpo266hSDdS7f1sV9dnxVhHBhCxWzN7+mfk4KzpjEVFoDR73X8IUOLGFikORl918i86bH2uqJ5zZLvOA4a0BqaRIExmAi7wQrm4iLcDH3THMpvEuy4965JZz1uPJYtGBD/Zj1O2sMA8K6zvSB/8q86fe1VdwIJxOHh50HqAH1jPHHfkxIdrL4nBmvF9Pkzpg/OWlyVjqWmWj0= hh"
      ]
  }
}

# can't use this in same chef-run
# because the uuid isn't available to feed to the machine_options
hanlon_image 'CoreOS' do
  #action :delete
  type 'os'
  path 'coreos_production_iso_image.iso'
  version '556'
  description 'Coreos stable'
end

# if the image is just created here... how do we use the fresh image in the next step?
# may be we should use the name instead of the image_uuid?

with_machine_options(
  image_uuid: '1E8qR0n0qFQavIIrLsSr04',
  model: {
    label: 'Deploying Coreos Again',
    template: 'coreos_stable',
    req_metadata_params: {
      hostname_prefix: 'pii',
      domainname: 'instantinfrastructure.com',
    }.merge(coreos_opts),
  },
  policy: {
    label_prefix: 'ii-core-baby',
    template: 'linux_deploy',
    # for now let's use the automatic hw_id tag
    #    tags: '00000000-0000-0000-0000-002590E252B8', #6
    tags: '00000000-0000-0000-0000-002590E254EC' #5
  }
)
  

machine 'coreos' do
  action :setup
  tag "coreos!"
  converge false
end
