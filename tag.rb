require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'
#require 'chef/provider/hanlon_image'
#require 'chef/resource/hanlon_image'
require 'pry'
with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

hanlon_tagrule 'Tagging box 6 with ' do
  #action :delete
  tag 'tagged'
  match %w{mk_ipmi_IP_Addres equal 1.1.0.6}
  # would like to use this syntax...
  #match 'mk_ipmi_IP_Addres' do
  #  equal '1.1.0.6'
  #end
end

"""json
   "4RlKAWmjx077lUfFIXrP0i": {
      "version": 2,
      "json": {
        "@uuid": "4RlKAWmjx077lUfFIXrP0i",
        "@version": 2,
        "@classname": "ProjectHanlon::Tagging::TagRule",
        "@is_template": false,
        "@noun": "tag",
        "@name": "6C",
        "@tag": "C",
        "@field": null,
        "@tag_matchers": [
          {
            "@uuid": "4gymm8an3sxKMzz6DRHK4e",
            "@version": 0,
            "@classname": "ProjectHanlon::Tagging::TagMatcher",
            "@is_template": false,
            "@noun": "tag/4RlKAWmjx077lUfFIXrP0i/matcher",
            "@key": "mk_ipmi_IP_Address",
            "@value": "1.1.0.6",
            "@compare": "equal",
            "@inverse": "false"
          }
        ]
      }
"""
