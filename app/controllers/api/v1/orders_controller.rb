module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authenticate_user_from_token!
      before_action :set_cart, only: [:create]
      before_action :set_order, only: [:update, :destroy]

      # User: Place an order
      def create
       if @cart.cart_items.empty?
    render json: { error: "Your cart is empty" }, status: :unprocessable_entity
    return
  end

  total_amount = @cart.cart_items.map { |item| item.product.price * item.quantity }.sum

  @order = Order.new(
    user: current_user,
    total_amount: total_amount,
    status: "pending",
    payment_method: params[:payment_method],
    address: params[:address]
  )

  if @order.save
    @cart.cart_items.each do |item|
      OrderItem.create!(
        order: @order,
        product: item.product,
        quantity: item.quantity,
        price: item.product.price
      )
    end

    @cart.cart_items.destroy_all

    render json: { message: "Order placed successfully", order: @order }, status: :created
  else
    render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
  end
end

     # GET /api/v1/orders
      def index
        orders = current_user.orders.order(created_at: :desc)
        render json: orders, status: :ok
      end

      # Admin: Update order (e.g., status)
      def update
        if current_user.admin?
          if @order.update(order_params)
            render json: { message: "Order updated", order: @order }
          else
            render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end

      # Admin: Delete order
      def destroy
        if current_user.admin?
          @order.destroy
          render json: { message: "Order deleted successfully" }
        else
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end

      private

      def order_params
        params.require(:order).permit(:status, :payment_method, :address)
      end

      def set_cart
        @cart = Cart.find_by(user_id: current_user.id)
      end

      def set_order
        @order = Order.find(params[:id])
      end
    end
  end
end
