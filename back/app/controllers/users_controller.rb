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
      return render json: { message: "Group doesn't exists" }, status: :not_found
    end
    @members = @group.members
    @manager = @members.find_by(managed_groups: @group)
  end

  def add_user_in_group
    begin
      user = User.find(params[:id])
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      return render json: { error: "User doesn't exists" }, status: :not_found
    end
    begin
      group = Group.find(params[:group])
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      return render json: { error: "Group doesn't exist" }, status: :not_found
    end
    user.groups << group
    if user.save!
      render json: { message: "User #{user.id} added to group!" }, status: :ok
    else
      render json: { message: "Error" }, status: :internal_server_error
    end
  end

  def create
    user = User.new(user_params)
    user.password = generated_password
    group = Group.find(params[:group])
    if group.blank?
      return render json: { message: "Group doesn't exists" }, status: :not_found
    end

    user.groups << group
    if user.save!
      render json: { message: "User #{user.email} created!" }, status: :created
    else
      render json: { error: "Error" }, status: :internal_server_error
    end
  end

  def delete_from_group
    begin
      user = User.find(params[:id])
      group = user.groups.where(id: params[:group]).try(:first)
      if group.blank?
        return render json: { error: "User doesn't exist!" }, status: :not_found
      end
      user.groups = user.groups.where_not(id: params[:group])
      if user.save!
        render json: { message: "User #{user.id} deleted from group!" }, status: :ok
      else
        render json: { message: "Error" }, status: :internal_server_error
      end
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      return render json: { error: "User doesn't exist" }, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:name, :email)
  end

  def generated_password
    chars = [*("a".."z"), *("A".."Z"), *(0..9), *[".,-´`+ç_:;*"]]
    (0...12).map { chars.to_a[rand(chars.length)] }.join
  end
end
