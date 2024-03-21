# frozen_string_literal: true
require 'csv'

class Cryptocurrency < ApplicationRecord

  def rate
    if exchange_rates[:rate]
      update(last_price: exchange_rates[:rate])
      exchange_rates[:rate]
    end
  rescue Exception => e
    last_price
  end

  private

  def exchange_rates
    @exchange_rates ||= coin_api_client.exchange_rates_get_specific_rate(asset_id_base: code, asset_id_quote: 'USD')
  end

  def coin_api_client
    @coin_api_client ||= CoinApi::Client.new(api_key: api_key)
  end

  def api_key
    '3CE685E6-4EA9-4BE5-BEBA-1A625ED130AB' #this value must be in ENV vars
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |cryptocurrency|
        csv << cryptocurrency.attributes.values_at(*column_names)
      end
    end
  end
end
