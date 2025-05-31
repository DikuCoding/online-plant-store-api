class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  #  this line to skip authentication for sign up
  skip_before_action :authenticate_user_from_token!, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    build_resource(sign_up_params)
    resource.role ||= :user
    resource.save
    respond_with(resource)
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { message: 'Signed up successfully.', user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

