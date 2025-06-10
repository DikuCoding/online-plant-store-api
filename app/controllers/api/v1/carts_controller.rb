class Api::V1::CartsController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :ensure_customer_only
  before_action :set_cart

  def show
    render json: {
      cart_id: @cart.id,
      items: @cart.cart_items.includes(:product).map do |item|
        {
          product_id: item.product.id,
          name: item.product.name,
          price: item.product.price,
          quantity: item.quantity
        }
      end
    }
  end

  private

  def set_cart
  if current_user
    @cart = current_user.cart || current_user.create_cart
  else
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end

end
