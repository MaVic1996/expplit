class AuthenticationController < AuthorizedController
  skip_before_action :authenticate_user, only: [:login, :register]

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JwtToken.encode(user_id: user.id)
      time = Time.now + 24.hours.to_i
      render_response(user)
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  def register
    if User.find_by(email: params[:email]).present?
      render json: { error: 'User already exists' }, status: :bad_request
    else
      begin
        user = User.new(email: params[:email], name: params[:name], password: params[:password])
        user.save!
        render_response(user)
      rescue ActiveGraph::Node::Persistence::RecordInvalidError => e
        render json: {error: e.message}, status: :bad_request
      end
    end 
  end

  private 

  def render_response(user)
    token = JwtToken.encode(user_id: user.id)
    time = Time.now + 24.hours.to_i
    render json: { 
      token: token, 
      exp: time.strftime("%m-%d-%Y %H:%M"),
      email: user.email
    }, status: :ok
  end

end