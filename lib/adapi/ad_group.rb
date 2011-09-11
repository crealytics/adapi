module Adapi
  class AdGroup < Api
  
    attr_accessor :campaign_id, :name, :bids, :keywords, :ads

    validates_presence_of :campaign_id, :name

    def attributes
      super.merge('campaign_id' => campaign_id, 'name' => name, 'bids' => bids)
    end

    def initialize(params = {})
      params[:service_name] = :AdGroupService

      @xsi_type = 'AdGroup'

      %w{ campaign_id name bids keywords ads }.each do |param_name|
        self.send "#{param_name}=", params[param_name.to_sym]
      end

      @keywords ||= []
      @ads ||= []

      super(params)
    end

    def create
      p self.attributes
      
      response = self.mutate(
        :operator => 'ADD', 
        :operand => {
          :campaign_id => @campaign_id,
          :name => @name,
          :bids => @bids
        }
      )

      ad_group = response[:value].first

      return false unless (response and response[:value])
      
      self.id = response[:value].first[:id] rescue nil
      
      if @keywords.size > 0
        Adapi::AdGroupCriterion.create(
          :ad_group_id => @id,
          :criteria => @keywords
        )
      end

      @ads.each do |ad_data|
        ad = Adapi::Ad::TextAd.create( ad_data.merge(:ad_group_id => @id) )
        p ad.errors.full_messages if (ad.errors.size > 0)
      end

      true
    end
 
    def self.find(amount = :all, params = {})
      params.symbolize_keys!
      first_only = (amount.to_sym == :first)

      raise "No Campaign ID is required" unless params[:campaign_id]

      predicates = [ :campaign_id, :id ].map do |param_name|
        if params[param_name]
          {:field => param_name.to_s.camelcase, :operator => 'EQUALS', :values => params[param_name] }
        end
      end.compact

      selector = {
        :fields => ['Id', 'Name', 'Status'],
        :ordering => [{:field => 'Name', :sort_order => 'ASCENDING'}],
        :predicates => predicates
      }

      response = AdGroup.new.service.get(selector)

      response = (response and response[:entries]) ? response[:entries] : []

      #response.map! do |data|
      #  TextAd.new(data[:ad].merge(:ad_group_id => data[:ad_group_id], :status => data[:status]))
      #end

      first_only ? response.first : response
    end

  end
end
