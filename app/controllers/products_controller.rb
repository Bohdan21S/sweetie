class ProductsController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]

  def index
    if params[:search].present?
      @products = Product.where("name LIKE ?", "%#{params[:search]}%").includes(:category)
    else
      @products = Product.all.includes(:category)
    end
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.includes(:user)
  end


end
