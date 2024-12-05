class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :delivery_method, presence: true
  validates :payment_method, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending confirmed completed canceled] }

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= 'pending'
  end
end
