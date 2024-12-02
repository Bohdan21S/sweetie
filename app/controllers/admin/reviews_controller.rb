module Admin
  class ReviewsController < ApplicationController
    before_action :authenticate_admin!

    def update
      @review = Review.find(params[:id])
      if @review.update(admin_response: params[:admin_response])
        redirect_to product_path(@review.product), notice: 'Відповідь додано.'
      else
        redirect_to product_path(@review.product), alert: 'Помилка при додаванні відповіді.'
      end
    end

    private

    def authenticate_admin!
      redirect_to root_path, alert: 'Доступ заборонений.' unless current_user&.admin?
    end
  end
end
