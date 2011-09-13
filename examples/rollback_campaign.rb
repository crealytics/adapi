
require 'adapi'

# create campaign by single command, with campaing targets, with ad_groups
# including keywords and ads

campaign_data = {
  :name => "Campaign #%d" % (Time.new.to_f * 1000).to_i,
  :status => 'PAUSED',
  # Automatic CPC: BudgetOptimizer or ManualCPC
  :bidding_strategy => { :xsi_type => 'BudgetOptimizer', :bid_ceiling => 100 },
  :budget => { :amount => 50, :delivery_method => 'STANDARD' },

  :network_setting => {
    :target_google_search => true,
    :target_search_network => true,
    :target_content_network => false,
    :target_content_contextual => false
  },

  :targets => {
    :language => [ 'en', 'cs' ],
    # TODO test together with city target
    :geo => { :proximity => { :geo_point => '38.89859,-77.035971', :radius => '10 km' } }
  },

  :ad_groups => [
    {
      :name => "AdGroup #%d" % (Time.new.to_f * 1000).to_i,
      :status => 'ENABLED',

      :keywords => [ 'dem codez', '"top coder"', "[-code]" ],

      :ads => [
        {
          :headline => "Code like Neo",
          :description1 => 'Need mad coding skills?',
          :description2 => 'Check out my new blog!',
          :url => '', # THIS FAILS
          :display_url => 'http://www.demcodez.com'
        }
      ]
    }
  ]

}
 
$campaign = Adapi::Campaign.create(campaign_data)

p "Campaign ID #{$campaign.id} created"
p "with status DELETED and changed name"
pp $campaign.attributes

p "with errors:"
pp $campaign.errors.to_a
