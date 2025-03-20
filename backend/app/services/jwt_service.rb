class JwtService
  SECRET_KEY = Rails.application.credentials.dig(:jwt_secret_key) || Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256', exp_leeway: 0 }).first.with_indifferent_access
  rescue JWT::ExpiredSignature
    raise JWT::ExpiredSignature
  rescue JWT::DecodeError
    nil
  end
end
