class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_review, only: %i[edit update]
  before_action :authorize_user!, only: %i[edit update]

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

  def edit
    @product = @review.product
  end

  def update
    if @review.update(review_params)
      redirect_to @review.product, notice: 'Ваш відгук успішно оновлено.'
    else
      flash.now[:alert] = 'Не вдалося оновити відгук.'
      render :edit
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content, images: [])
  end

  def find_review
    @review = Review.find(params[:id])
  end

  def authorize_user!
    redirect_to @review.product, alert: 'Ви не можете редагувати цей відгук.' unless @review.user == current_user
  end
end
