class Api::V1::CartItemsController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :ensure_customer_only
  before_action :set_cart

  def index
    cart_items = @cart.cart_items.includes(:product)

    render json: cart_items.as_json(
      include: {
        product: {
          only: [:id, :name, :description, :price]
        }
      },
      only: [:id, :quantity]
    ), status: :ok
  end

  def create
    Rails.logger.debug "Current user: #{current_user&.email}"
    Rails.logger.debug "Cart: #{@cart.inspect}"

    item = @cart.cart_items.find_by(product_id: params[:cart_item][:product_id])

    if item
      item.quantity += params[:cart_item][:quantity].to_i
      action = 'updated'
    else
      item = @cart.cart_items.build(cart_item_params)
      action = 'added'
    end

    if item.save
      render json: {
        message: "Item successfully #{action} in cart",
        item: item
      }, status: :ok
    else
      Rails.logger.error "Failed to save item: #{item.errors.full_messages}"
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
  item = @cart.cart_items.find_by(id: params[:id])

  if item
    item.quantity = params[:cart_item][:quantity].to_i
    if item.save
      render json: { message: 'Cart item updated successfully', item: item }, status: :ok
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  else
    render json: { error: 'Item not found in cart' }, status: :not_found
  end
end


  def destroy
    item = @cart.cart_items.find_by(product_id: params[:product_id])
    if item&.destroy
      render json: { message: 'Item removed from cart' }
    else
      render json: { error: 'Item not found' }, status: :not_found
    end
  end

  private

  def set_cart
    if current_user
      Rails.logger.debug "Authenticated user: #{current_user.email}"
      @cart = Cart.find_or_initialize_by(user_id: current_user.id)
      if @cart.new_record?
        @cart.save(validate: false)
        Rails.logger.debug "New cart created and saved: #{@cart.inspect}"
      else
        Rails.logger.debug "Cart found: #{@cart.inspect}"
      end
    else
      Rails.logger.error "User not authenticated - JWT missing or invalid"
      render json: { error: 'Unauthorized - please provide a valid token' }, status: :unauthorized
    end
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
