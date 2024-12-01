class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_items = current_user.cart.cart_items.includes(:product)
  end
end
