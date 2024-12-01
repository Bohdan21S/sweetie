class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    cart = current_user.cart || current_user.create_cart
    cart_item = cart.cart_items.find_by(product_id: params[:product_id])

    if cart_item
      cart_item.quantity += params[:quantity].to_i
    else
      cart_item = cart.cart_items.new(product_id: params[:product_id], quantity: params[:quantity])
    end

    if cart_item.save
      redirect_to cart_path, notice: 'Товар додано до корзини.'
    else
      redirect_to products_path, alert: 'Не вдалося додати товар до корзини.'
    end
  end


  def destroy
    cart_item = current_user.cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: 'Товар видалено з корзини.'
  end

  def update
    cart_item = current_user.cart.cart_items.find(params[:id])
    if cart_item.update(quantity: params[:quantity])
      redirect_to cart_path, notice: 'Кількість оновлено.'
    else
      redirect_to cart_path, alert: 'Не вдалося оновити кількість.'
    end
  end

end
