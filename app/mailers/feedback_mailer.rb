class FeedbackMailer < ApplicationMailer
  default to: ENV['ADMIN_EMAIL']

  def send_feedback(feedback)
    @feedback = feedback
    attachments_from_feedback(@feedback)
    mail(subject: "Нове звернення: #{@feedback.subject}")
  end

  private

  def attachments_from_feedback(feedback)
    feedback.images.each do |image|
      attachments[image.filename.to_s] = image.download
    end
  end
end
