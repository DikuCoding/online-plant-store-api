class PaymentsController < ApplicationController
  def create
    payment = Payment.new(payment_params)
    if payment.save
      render json: payment, status: :created
    else
      render json: payment.errors, status: :unprocessable_entity
    end
  end

  def show
    payment = Payment.find(params[:id])
    render json: payment
  end

  private

  def payment_params
    params.permit(:order_id, :payment_method, :amount, :status)
  end
end
