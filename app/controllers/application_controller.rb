class ApplicationController < ActionController::Base
  # Disable CSRF protection for APIs, but keep it for regular requests
  protect_from_forgery with: :null_session

  # Optional: Allow JSON requests only (you can customize as needed)
  before_action :ensure_json_request

  private

  def ensure_json_request
    return if request.format.json?
    render json: { error: 'Not Acceptable' }, status: 406
  end
end

