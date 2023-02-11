class AuthorizedController < ApplicationController
  include JwtToken

  before_action :authenticate_user

  def authenticate_user
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    begin
      @decoded = JwtToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
