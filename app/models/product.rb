class Product < ApplicationRecord
  has_one_attached :image

  # Add validations if you want, for example:
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
