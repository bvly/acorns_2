require 'faraday'

class EdmundsAPITest
  @@url = 'https://api.edmunds.com/api'
  @@conn = Faraday.new
  def initialize(apiKey)
    @apiKey = apiKey
  end
  def findVehicle(year)
    response = @@conn.get '%s/vehicle/v2/makes?year=%s&fmt=json&api_key=%s' % [@@url, year, @apiKey]
    response
  end
end
