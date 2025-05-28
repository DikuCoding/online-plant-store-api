class CartItemsController < ApplicationController
  def create
    cart = Cart.find_or_create_by(user_id: params[:user_id])
    product = Product.find(params[:product_id])

    cart_item = cart.cart_items.find_by(product_id: product.id)
    if cart_item
      cart_item.quantity += params[:quantity].to_i
    else
      cart_item = cart.cart_items.new(product: product, quantity: params[:quantity])
    end

    if cart_item.save
      render json: cart_item, status: :created
    else
      render json: cart_item.errors, status: :unprocessable_entity
    end
  end

  def update
    cart_item = CartItem.find(params[:id])
    if cart_item.update(quantity: params[:quantity])
      render json: cart_item
    else
      render json: cart_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    head :no_content
  end
end
