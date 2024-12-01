class Product < ApplicationRecord
  belongs_to :category
  # has_many :reviews

  has_one_attached :image

  has_many :reviews, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than: 0 }, allow_nil: true
end
