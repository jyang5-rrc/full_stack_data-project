
require 'httparty'

class MakeupApi
  include HTTParty
  base_uri 'http://makeup-api.herokuapp.com'

  def self.fetch_products
    response = get('/api/v1/products.json')
    if response.success?
      response
    else
      Rails.logger.error("MakeupApi.fetch_products error: #{response}")
      nil
    end
  end
end
