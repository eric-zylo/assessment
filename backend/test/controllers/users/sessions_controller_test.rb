require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = FactoryBot.create(:user)
    @protected_url = user_path(@user)
  end

  test "JWT token is properly encrypted and can be decrypted" do
    token = generate_jwt(@user)
  
    decoded_token = JwtService.decode(token)
    
    assert_equal @user.id, decoded_token["user_id"]
  end

  test "should create session and set JWT cookie on successful login" do
    post user_session_url, params: { user: { email: @user.email, password: "Valid1!!" } }, as: :json
  
    assert_response :ok
    assert response.cookies["jwt"].present?, "JWT cookie was not set"
  end
  
  test "should return unauthorized on invalid login" do
    post user_session_url, params: { user: { email: @user.email, password: "wrong_password" } }, as: :json
    assert_response :unauthorized
    assert response.cookies["jwt"].nil?
  end

  test "should delete JWT cookie on logout" do
    post user_session_url, params: { user: { email: @user.email, password: "password" } }, as: :json
    delete destroy_user_session_url, as: :json
    assert_response :ok
    assert response.cookies["jwt"].nil?
  end

  test "should return bad request on missing login parameters" do
    post user_session_url, params: { user: { email: @user.email } }, as: :json
    assert_response :bad_request
  end

  test "should return unauthorized if JWT is expired" do
    expired_token = generate_jwt(@user, exp: 1.hour.ago.to_i)
  
    get @protected_url, headers: { "Cookie" => "jwt=#{expired_token}" }
    
    assert_response :unauthorized
  end

  test "should return unauthorized when accessing a protected route without JWT" do
    get @protected_url
    
    assert_response :unauthorized
    assert response.body.include?("Unauthorized")
  end

  test "should allow access to protected route with valid JWT" do
    token = generate_jwt(@user)
  
    get @protected_url, headers: { "Authorization" => "Bearer #{token}" }
  
    assert_response :ok
    assert response.body.include?(@user.email)
  end

  test "should handle logout when not logged in" do
    delete destroy_user_session_url, as: :json
    assert_response :ok
  end

  test "should return unauthorized for invalid JWT" do
    cookies[:jwt] = "invalid_token"
  
    get @protected_url, headers: { "Cookie" => "jwt=invalid_token" }
  
    assert_response :unauthorized
  end

  private

  def generate_jwt(user, exp: 24.hours.from_now)
    JwtService.encode({ user_id: user.id, exp: exp.to_i })
  end
end
