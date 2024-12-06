module Admin
  class OrdersController < ApplicationController
    before_action :authenticate_admin!

    def index
      @orders = Order.where.not(status: 'canceled').order(created_at: :desc)
    end

    def update
      @order = Order.find(params[:id])

      if params[:status].present? && %w[sent completed].include?(params[:status])
        @order.update(status: params[:status])
        flash[:notice] = "Замовлення №#{@order.id} позначено як #{params[:status]}."
      else
        flash[:alert] = 'Невірний статус замовлення.'
      end

      redirect_to admin_orders_path
    end

    def destroy
      @order = Order.find(params[:id])
      @order.update(status: 'canceled')
      flash[:notice] = "Замовлення №#{@order.id} скасовано."
      redirect_to admin_orders_path
    end

    def show
      @order = Order.find(params[:id])
      @order_items = @order.order_items.includes(:product) # Завантажуємо пов’язані товари для оптимізації
    end

    private

    def authenticate_admin!
      redirect_to root_path, alert: 'Доступ заборонений.' unless current_user&.admin?
    end
  end
end
