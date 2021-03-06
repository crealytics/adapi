# encoding: utf-8

# This example should throw an error on ad.url

require 'adapi'

require_relative 'add_bare_campaign'

ad_group_data = {
  :name => "AdGroup #%d" % (Time.new.to_f * 1000).to_i,
  :status => 'ENABLED',
  :campaign_id => $campaign[:id],

  :keywords => [ 'dem codez', '"top coder"', '[-code]' ],

  :ads => [
    {
      :headline => "Code like Neo",
      :description1 => 'Need mad coding skills?',
      :description2 => 'Check out my new blog!',      
      # this should throw an error
      :url => 'http://www.demcodez.com THIS IS INVALID',
      :display_url => 'http://www.demcodez.com'
    }
  ]
}
 
$ad_group = Adapi::AdGroup.create(ad_group_data)

unless $ad_group.errors.empty?

  puts "ERROR WHEN CREATING AD GROUP:"
  pp $ad_group.errors.full_messages

else

  puts "AD GROUP #{$ad_group[:id]} CREATED"
  pp $ad_group.attributes

end
