class OrdersController < ApplicationController
  def index
    orders = Order.where(user_id: params[:user_id])
    render json: orders.as_json(include: :order_items)
  end

  def show
    order = Order.find(params[:id])
    render json: order.as_json(include: :order_items)
  end

  def create
    order = Order.new(order_params)
    if order.save
      params[:order_items].each do |item|
        order.order_items.create(
          product_id: item[:product_id],
          quantity: item[:quantity],
          price: item[:price]
        )
      end
      render json: order.as_json(include: :order_items), status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def update
    order = Order.find(params[:id])
    if order.update(order_params)
      render json: order
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.permit(:user_id, :total_price, :status)
  end
end
