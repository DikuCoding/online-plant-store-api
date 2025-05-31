class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user_from_token!
  respond_to :json

  def create
    puts "Login Attempt Email: #{params[:user][:email]}"

    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      sign_in(user)

      token = generate_jwt_token(user)

      render json: {
        status: 'success',
        message: 'Logged in successfully',
        token: token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role
        }
      }, status: :ok
    else
      render json: { status: 'error', message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    sign_out(resource_name)
    render json: { status: 'success', message: 'Logged out successfully' }, status: :ok
  end

  private

  def generate_jwt_token(user)
    payload = {
      sub: user.id,
      scp: user.role,
      iat: Time.now.to_i,
      exp: 24.hours.from_now.to_i,
      jti: SecureRandom.uuid
    }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
end
