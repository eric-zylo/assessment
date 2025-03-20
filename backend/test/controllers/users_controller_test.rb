require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryBot.create(:user)
    @token = JwtService.encode(user_id: @user.id)
    @expired_token = JwtService.encode({ user_id: @user.id }, 1.hour.ago.to_i)
  end

  test "should return user info when authenticated" do
    get user_url(@user), headers: generate_headers_with_token(@token)

    assert_response :success
    assert_equal @user.id, json_response["id"]
    assert_equal @user.email, json_response["email"]
  end

  test "should return unauthorized when no token is provided" do
    get user_url(@user)

    assert_response :unauthorized
    assert_equal Errors::UNAUTHORIZED_NO_TOKEN, json_response["error"]
  end

  test "should return unauthorized for invalid token" do
    get user_url(@user), headers: generate_headers_with_token('invalid_token')

    assert_response :unauthorized
  end

  test "should return unauthorized for expired token" do
    get user_url(@user), headers: generate_headers_with_token(@expired_token)
  
    assert_response :unauthorized
    assert_equal Errors::UNAUTHORIZED_EXPIRED_TOKEN, json_response["error"]
  end

  test "should return unauthorized if token is missing user_id" do
    bad_token = JwtService.encode({})
    get user_url(@user), headers: generate_headers_with_token(bad_token)
  
    assert_response :unauthorized
    assert_equal Errors::UNAUTHORIZED_INVALID_TOKEN, json_response["error"]
  end

  test "should return unauthorized for token with wrong signature" do
    other_secret_token = JWT.encode({ user_id: @user.id }, "wrong_secret", "HS256")
    get user_url(@user), headers: generate_headers_with_token(other_secret_token)
  
    assert_response :unauthorized
    assert_equal Errors::UNAUTHORIZED_INVALID_TOKEN, json_response["error"]
  end

  test "should return unauthorized if token references non-existent user" do
    deleted_user_token = JwtService.encode(user_id: 0)
    get user_url(@user), headers: generate_headers_with_token(deleted_user_token)
  
    assert_response :unauthorized
    assert_equal Errors::UNAUTHORIZED_INVALID_TOKEN, json_response["error"]
  end

  private

  def generate_headers_with_token(token)
    { "Authorization" => "Bearer #{token}" }
  end

  def json_response
    JSON.parse(response.body)
  end
end
