require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class JwtAuthenticatable < Authenticatable
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        token = request.headers['Authorization'].split(' ').last
        decoded_token = JwtService.decode(token)

        if decoded_token && user = User.find_by(id: decoded_token['user_id'])
          success!(user)
        else
          fail!
        end
      end
    end
  end
end
