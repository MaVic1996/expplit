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
    @group = Group.find(params[:group])
    if @group.blank?
      return render json: {message: "Group doesn't exists"}, status: :not_found 
    end
    @members = @group.members
    @manager = @members.find_by(managed_groups: @group)
  end

  def add_user_in_group
      
  end

  def create
    user = User.new(user_params)
    user.password = generated_password 
    group = Group.find(params[:group])
    if group.blank?
      return render json: {message: "Group doesn't exists"}, status: :not_found 
    end

    user.groups << group    
    if user.save!
      render json: {message: "User #{user.email} created!"}, status: :created
    else
      render json: {error: "Error" }, status: :internal_server_error
    end
  end
  def delete_from_group
    # binding.break
    # exist_user =  ActiveGraph::Base.query("Match(n1:User)-[:BELONGS_TO]->(g:Group)-[:MANAGED_BY]->(n2:User) where n1 <> n2 AND n1.uuid = '#{params[:id]}' return n1.uuid").count > 0
    # if !exist_user
    #   return render json: {message: "User doesn't exist in this group!"}, status: :not_found
    # end
    # user.group_ids = user.groups_id.select{|gid| gid != params[:group]}
    # if user.save!
    #   render json: {message: "User #{user.email} deleted successfully"}, status: :ok
    # else
    #   render json: {message: "Something went wrong trying to delete the user"}, status: :internal_server_error
    # end
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