class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      FeedbackMailer.send_feedback(@feedback).deliver_now
      redirect_to new_feedback_path, notice: 'Ваше повідомлення успішно відправлено.'
    else
      render :new, alert: 'Помилка при відправленні повідомлення.'
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:subject, :message, images: [])
  end
end
