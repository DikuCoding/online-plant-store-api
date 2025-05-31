# app/controllers/api/v1/admin/products_controller.rb
class Api::V1::Admin::ProductsController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authorize_admin!

  def create
    product = Product.new(product_params)
    if product.save
      render json: { message: 'Product created successfully', product: product_response(product) }, status: :created
    else
      render json: { error: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      render json: { message: 'Product updated successfully', product: product_response(product) }, status: :ok
    else
      render json: { error: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])
    if product.destroy
    render json: { message: 'Product deleted successfully' }, status: :ok
  else
    render json: { error: 'Failed to delete product' }, status: :unprocessable_entity
  end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity  , :image)
  end

  def authorize_admin!
    unless current_user && current_user.admin?
      render json: { error: 'Unauthorized - Admin only' }, status: :unauthorized
    end
  end

  def product_response(product)
    {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      stock_quantity: product.stock_quantity,
      image_url: product.image.attached? ? url_for(product.image) : nil
    }
  end

  def authenticate_user_from_token!
  header = request.headers['Authorization']
  token = header.split(' ').last if header
  begin
    decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
    payload = decoded_token.first
    @current_user = User.find(payload['sub']) # ✅ use 'sub' as it's your user_id
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Unauthorized or invalid token' }, status: :unauthorized
  end
end
end
