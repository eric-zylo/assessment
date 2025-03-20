class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authenticate_request

  private

  def authenticate_request
    token = extract_token
    return render json: { error: Errors::UNAUTHORIZED_NO_TOKEN }, status: :unauthorized unless token
  
    begin
      decoded_token = JwtService.decode(token)
      return render json: { error: Errors::UNAUTHORIZED_INVALID_TOKEN }, status: :unauthorized unless decoded_token
  
      @current_user = User.find(decoded_token[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: Errors::UNAUTHORIZED_INVALID_TOKEN }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { error: Errors::UNAUTHORIZED_EXPIRED_TOKEN }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: Errors::UNAUTHORIZED_INVALID_TOKEN }, status: :unauthorized
    end
  end
  

  def extract_token
    auth_header = request.headers["Authorization"]
    return auth_header.split(" ").last if auth_header.present?

    cookies.signed[:jwt]
  end

  def current_user
    @current_user
  end
end
