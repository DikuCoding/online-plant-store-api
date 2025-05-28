class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

end
