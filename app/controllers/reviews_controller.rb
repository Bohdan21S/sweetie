class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'Ваш відгук успішно додано.'
    else
      redirect_to @product, alert: 'Помилка при додаванні відгуку.'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content, images: [])
  end
end
