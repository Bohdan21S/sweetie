class Feedback < ApplicationRecord
  has_many_attached :images

  validates :subject, presence: true, length: { maximum: 100 }
  validates :message, presence: true, length: { minimum: 10 }
end
