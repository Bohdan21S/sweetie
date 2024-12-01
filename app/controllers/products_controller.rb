class ProductsController < ApplicationController

  # before_action :authenticate_user!, except: %i[index show]

  def index
    @products = Product.all.includes(:category)
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.includes(:user)
  end


end
