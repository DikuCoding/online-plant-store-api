class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate_user_from_token!

  def index
        if params[:query].present?
      # Search by name or description (case-insensitive)
          products = Product.where("name ILIKE :q OR description ILIKE :q", q: "%#{params[:query]}%").with_attached_image
        else
          products = Product.all.with_attached_image
        end

        render json: products.map { |product|
          {
            id: product.id,
            name: product.name,
            description: product.description,
            price: product.price,
            stock_quantity: product.stock_quantity,
            image_url: product.image.attached? ? url_for(product.image) : nil
          }
        }, status: :ok
  end

   def show
        product = Product.find(params[:id])

        render json: {
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          stock_quantity: product.stock_quantity,
          image_url: product.image.attached? ? url_for(product.image) : nil
        }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Product not found" }, status: :not_found
      end

  private
  
  def serialize_product(product)
        {
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          stock: product.stock,
          image_url: product.image.attached? ? url_for(product.image) : nil
        }
  end

end
