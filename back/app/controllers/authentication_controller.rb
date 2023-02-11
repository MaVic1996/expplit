class AuthenticationController < AuthorizedController
  skip_before_action :authenticate_user, only: [:login, :register]

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JwtToken.encode(user_id: user.id)
      time = Time.now + 24.hours.to_i
      user.last_login_at = DateTime.now
      user.save
      return render_response(user)
    end

    render json: { error: "unauthorized" }, status: :unauthorized
  end

  def register
    if User.find_by(email: params[:email]).present?
      return render json: { error: "User already exists" }, status: :bad_request
    end
    begin
      user = User.new(email: params[:email], name: params[:name], password: params[:password])
      user.last_login_at = DateTime.now
      user.save!
      render_response(user)
    rescue ActiveGraph::Node::Persistence::RecordInvalidError => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def vinculate_account
    user = User.find_by(email: params[:email])
    if user.blank?
      return render json: { error: "User email doesn't exists" }, status: :unauthorized
    end

    if user.last_login_at.present?
      return render json: { error: "User already logged in!" }, status: :bad_request
    end
    user.password = params[:password]
    user.last_login_at = DateTime.now
    if user.save!
      return render_response(user)
    else
      return render json: { error: "Error when vinculate account" }, status: :bad_request
    end
  end

  private

  def render_response(user)
    token = JwtToken.encode(user_id: user.id)
    time = Time.now + 24.hours.to_i
    render json: {
      token: token,
      exp: time.strftime("%m-%d-%Y %H:%M"),
      email: user.email,
    }, status: :ok
  end
end
