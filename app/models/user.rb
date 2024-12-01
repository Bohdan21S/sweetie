class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Оголошуємо ролі
  # for Rails 8.0
  enum :role, { user: 0, admin: 1 }

  # for other -v
  # enum role: { user: 0, admin: 1 }

  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :user
  end

  has_one :cart, dependent: :destroy

  after_create :initialize_cart

  def initialize_cart
    create_cart
  end


end
