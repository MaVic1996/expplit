class UsersController < AuthorizedController
  
  def my_data
    @user = @current_user
  end

  def user_data
    begin
      @user = User.find(params[:id])
      @common_groups = Group.where(member_ids: [@user.id, @current_user.id])
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      render json: { errors: e.message }, status: :not_found
    end
  end

  def list_from_group
    
  end

  def add_user_in_group
      
  end

  def create
    user = User.new(user_params)
    user.password = generated_password 
    user.logged_in_before = false
    if user.save!
      render json: {message: "User #{user.email} created!"}, status: :created
    else
      render json: {error: "Error" }, status: :bad_request
    end
  end

  def delete_from_group

  end

  private 

  def user_params
    params.permit(:name, :email)
  end

  def generated_password
    chars = [*('a'..'z'), *('A'..'Z'), *(0..9), *[".,-´`+ç_:;*"]]
    (0...12).map { chars.to_a[rand(chars.length)] }.join
  end

end