class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    products = Product.all
    render json: products.as_json(methods: [:image_url])
  end

  def show
    render json: @product.as_json(methods: [:image_url])
  end

  def create
    product = Product.new(product_params)
    if product.save
      product.image.attach(params[:image]) if params[:image]
      render json: product.as_json(methods: [:image_url]), status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      @product.image.attach(params[:image]) if params[:image]
      render json: @product.as_json(methods: [:image_url])
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.permit(:name, :description, :price, :stock_quantity)
  end
end
