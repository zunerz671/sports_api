class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  before_action :authorize_request

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = User.find(decoded["user_id"])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  allow_browser versions: :modern

  protect_from_forgery with: :null_session,
                       if: -> { request.format.json? }
end
