# app/controllers/api/v1/admin/orders_controller.rb
module Api
  module V1
    module Admin
      class OrdersController < ApplicationController
        before_action :authenticate_user_from_token!
        before_action :authorize_admin!
        before_action :set_order, only: [:admin_update, :admin_destroy]

        # GET /api/v1/admin/orders
        def admin_index
          orders = Order.includes(:user).order(created_at: :desc)
          render json: orders.as_json(include: { user: { only: [:id, :email] } }), status: :ok
        end

        # PUT /api/v1/admin/orders/:id
        def admin_update
          if @order.update(order_params)
            render json: { message: "Order updated successfully", order: @order }, status: :ok
          else
            render json: { error: "Failed to update order", details: @order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/orders/:id
        def admin_destroy
          if @order.destroy
            render json: { message: "Order deleted successfully" }, status: :ok
          else
            render json: { error: "Failed to delete order" }, status: :unprocessable_entity
          end
        end

        private

        def set_order
          @order = Order.find_by(id: params[:id])
          render json: { error: "Order not found" }, status: :not_found unless @order
        end

        def order_params
          params.require(:order).permit(:status, :payment_method, :address)
        end

        def authorize_admin!
          unless current_user&.admin?
            render json: { error: "Unauthorized. Admin access required." }, status: :unauthorized
          end
        end
      end
    end
  end
end
