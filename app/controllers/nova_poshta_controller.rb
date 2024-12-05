class NovaPoshtaController < ApplicationController
  def branches
    city = params[:city]
    branches = NovaPoshtaApi.get_branches(city) # Реалізація цього методу далі
    render json: branches
  end

  def cities
    query = params[:query]
    cities = NovaPoshtaApi.get_cities(query) # Отримання списку міст
    render json: cities
  end
end
