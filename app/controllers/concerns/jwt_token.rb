require "jwt"

module JwtToken
  extend ActiveSupport::Concern

  SECRET_KEY = ENV['JWT_SECRET']

  def self.encode(payload, exp=7.days.from_now)
    payload[:exp] = exp.to_i 
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token. SECRET_KEY)[0]
    HashWithIndifferent.new(decoded)
    end
end