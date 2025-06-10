class ApplicationController < ActionController::API

  before_action :authenticate_user_from_token!

  # Disable CSRF protection for APIs, but keep it for regular requests
  # protect_from_forgery with: :null_session

  # Optional: Allow JSON requests only (you can customize as needed)
  before_action :ensure_json_request

  private

  def authenticate_user_from_token!
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    begin
      decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      payload = decoded_token.first
      @current_user = User.find(payload['sub']) # use 'sub' from payload

    rescue JWT::DecodeError => e
      render json: { error: "Unauthorized or invalid token: #{e.message}" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :unauthorized
    end
    Rails.logger.debug "Authenticated user: #{@current_user.inspect}"

  end

  def ensure_json_request
    return if request.format.json?
    render json: { error: 'Not Acceptable' }, status: 406
  end

  def ensure_customer_only
    if @current_user&.admin?
      render json: { error: 'Admins are not allowed to perform this action' }, status: :forbidden
    end
  end

  def current_user
    @current_user
  end
  helper_method :current_user if respond_to?(:helper_method) # optional for views

  
end

