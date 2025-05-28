class CartsController < ApplicationController
  def show
    cart = Cart.find_by(user_id: params[:user_id])
    if cart
      render json: cart.as_json(include: { cart_items: { include: :product } })
    else
      render json: { error: "Cart not found" }, status: :not_found
    end
  end
end
