require 'chef/provisioning'
require 'chef/provisioning/hanlon_driver/hanlon_driver'
#require 'chef/provider/hanlon_image'
#require 'chef/resource/hanlon_image'
require 'pry'
with_driver 'hanlon:1.1.1.11:8026/hanlon/api/v1'

#hanlon_tagrule 'Tagging one box' do
#  tag 'tagged'
#  match %w{mk_ipmi_IP_Addres equal 1.1.0.6}
#end

# like this dsl better, but not sure how to do it
hanlon_tag 'Tag one with A' do
  match 'mk_ipmi_IP_Address' { equal '1.1.1.1' }
  tag 'A'
end

hanlon_tag 'Tag one with 1' do
  match 'mk_ipmi_IP_Address' { equal '1.1.1.1' }
  tag '1'
end

hanlon_tag 'Tag one with 1' do
  match 'mk_ipmi_IP_Address' { like '1.1.1.1' }
  tag '1'
end

hanlon_tag 'Tag two with A' do
  match 'mk_ipmi_IP_Addres' { equal '1.1.1.1' }
  tag 'A'
end

# field value tags
hanlon_tag 'Product' do
  field 'mk_hw_bus_product'
end

hanlon_tag 'Serial' do
  field 'mk_hw_bus_serial'
end

#    "mk_hw_bus_product": "X9SRD-F",
#    "mk_hw_bus_vendor": "Supermicro",
#    "mk_hw_bus_serial": "ZM28S45630",


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
