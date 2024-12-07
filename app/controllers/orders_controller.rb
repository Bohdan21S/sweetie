class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart_items = current_user.cart.cart_items.includes(:product)
    @total_price = @cart_items.sum { |item| item.product.price * item.quantity }
    @order = Order.new
  end

  def create
    @cart_items = current_user.cart.cart_items

    # Обчислюємо загальну суму замовлення
    total_price = @cart_items.sum { |item| item.product.price * item.quantity }

    # Створюємо замовлення
    @order = current_user.orders.new(order_params)
    @order.total_price = total_price

    # Заповнюємо поле місця доставки залежно від методу доставки
    case @order.delivery_method
    when 'Самовивіз'
      @order.delivery_location = @order.pickup_location
    when 'Нова Пошта'
      @order.delivery_location = @order.nova_poshta_branch
    end

    # Валідації даних банківської карти
    if @order.payment_method == 'Карта на сайті'
      card_number = params[:card_number]
      card_expiry = params[:card_expiry]
      card_cvv = params[:card_cvv]

      unless card_number.present? && card_expiry.present? && card_cvv.present?
        flash[:alert] = "Дані карти є обов'язковими для оплати онлайн."
        return render :new
      end
      # Інтеграція з хз який вибрати або монобанк або ліквідпей
    end

    if @order.save
      # Зберігаємо товари з корзини у замовлення
      @cart_items.each do |item|
        @order.order_items.create!(
          product: item.product,
          quantity: item.quantity,
          price: item.product.price
        )
      end

      # Очищуємо корзину після створення замовлення
      current_user.cart.cart_items.destroy_all
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
    params.require(:order).permit(
      :delivery_method,
      :pickup_location,
      :nova_poshta_branch,
      :payment_method
    )
  end
end
