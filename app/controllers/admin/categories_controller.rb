module Admin
  class CategoriesController < ApplicationController
    before_action :authenticate_admin!

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to root_path, notice: 'Категорію успішно додано.'
      else
        render :new, alert: 'Помилка при додаванні категорії.'
      end
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end

    def authenticate_admin!
      redirect_to root_path, alert: 'Доступ заборонений.' unless current_user&.admin?
    end
  end
end
