class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart_items = current_user.cart.cart_items.includes(:product)
    @total_price = @cart_items.sum { |item| item.product.price * item.quantity }
    @order = Order.new
  end

  def create
    @order = current_user.orders.new(order_params)
    @cart_items = current_user.cart.cart_items

    if @order.save
      @cart_items.each do |item|
        @order.order_items.create!(
          product: item.product,
          quantity: item.quantity,
          price: item.product.price
        )
      end
      current_user.cart.cart_items.destroy_all # Очищуємо корзину після створення замовлення
      redirect_to @order, notice: 'Замовлення створено успішно!'
    else
      render :new, alert: 'Помилка при створенні замовлення.'
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:delivery_method, :delivery_location, :payment_method, :total_price)
  end
end
