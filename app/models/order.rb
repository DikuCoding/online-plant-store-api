class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :payment

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
end
