class Users::SessionsController < Devise::SessionsController
  include ActionController::Cookies

  skip_before_action :authenticate_request, only: [:create]

  respond_to :json

  def create
    if params.dig(:user, :email).blank? || params.dig(:user, :password).blank?
      return render json: { error: "Missing email or password" }, status: :bad_request
    end

    super do |user|
      if user.persisted?
        set_jwt_cookie(user)
      end
    end
  end

  private

  def set_jwt_cookie(user)
    token = JwtService.encode(user_id: user.id)

    cookies.signed[:jwt] = { 
      value: token, 
      httponly: true, 
      same_site: :strict, 
      secure: Rails.env.test? ? false : Rails.env.production? 
    }
  end

  def respond_with(resource, _opts = {})
    if resource.valid_password?(params[:user][:password])
      set_jwt_cookie(resource)
      render json: { message: 'Logged in successfully' }, status: :ok
    else
      render json: { error: "Login Failed" }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    cookies.delete(:jwt)
    render json: { message: "Logged out successfully" }, status: :ok
  end
end
