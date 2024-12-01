module Admin
  class ProductsController < ApplicationController
    before_action :authenticate_admin!

    def new
      @product = Product.new
      @categories = Category.all
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to root_path, notice: 'Товар успішно додано.'
      else
        @categories = Category.all
        render :new, alert: 'Помилка при додаванні товару.'
      end
    end

    private

    def product_params
      params.require(:product).permit(:name, :price, :weight, :description, :category_id, :image)
    end

    def authenticate_admin!
      redirect_to root_path, alert: 'Доступ заборонений.' unless current_user&.admin?
    end
  end
end
