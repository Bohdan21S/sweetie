class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many_attached :images

  validates :rating, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :content, presence: true, length: { minimum: 10 }

  validates :admin_response, length: { maximum: 500 }, allow_blank: true
end
