require 'net/http'
require 'json'

class NovaPoshtaApi
  BASE_URL = 'https://api.novaposhta.ua/v2.0/json/'

  def self.get_branches(city)
    api_key = ENV['NOVA_POSHTA_API_KEY'] # Встановіть API-ключ у .env
    body =
    #   {
    #   "apiKey": api_key,
    #   "modelName": "AddressGeneral",
    #   "calledMethod": "getWarehouses",
    #   "methodProperties": {
    #     "CityName": city
    #   }
    # }
      {
      apiKey: api_key,
      modelName: 'AddressGeneral',
      calledMethod: 'getWarehouses',
      methodProperties: { CityName: city }
    }

    response = Net::HTTP.post(
      URI(BASE_URL),
      body.to_json,
      { 'Content-Type': 'application/json' }
    )

    data = JSON.parse(response.body)
    if data['success']
      data['data'].map { |branch| branch['Description'] }
    else
      ["PARSING DATA ERROR"]
    end
  end



  def self.get_cities(query)
    api_key = ENV['NOVA_POSHTA_API_KEY'] # Додайте ваш API-ключ у .env
    body = {
      apiKey: api_key,
      modelName: 'Address',
      calledMethod: 'getCities',
      methodProperties: {
        FindByString: query
      }
    }

    response = Net::HTTP.post(
      URI(BASE_URL),
      body.to_json,
      { 'Content-Type': 'application/json' }
    )

    data = JSON.parse(response.body)
    if data['success']
      data['data'].map { |city| city['Description'] }
    else
      ["PARSING DATA ERROR"]
    end
  end



end
