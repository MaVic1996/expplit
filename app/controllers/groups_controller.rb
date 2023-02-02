class GroupsController < AuthorizedController

  def member_groups
    @groups = @current_user.groups
  end

  def managed_groups
    @groups = Group.where(manager: @current_user)
  end

  def show
    begin
      @group = Group.find(params[:id])
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      return render json: { message: e.message }, status: :not_found
    end
  end

  def update
    begin
      group = Group.find(params[:id])
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      return render json: { message: "Group not found" }, status: :not_found
    end
    if group.update(group_params)
      render json: {
        id: group.id,
      }, status: :accepted
    else
      render json: { message: "Group cannot be updated" }, status: :bad_request
    end
  end

  def create
    new_group = Group.new(group_params)
    new_group.members << @current_user
    new_group.manager = @current_user

    if new_group.save
      render json: {
        id: new_group.id,
      }, status: :created
    else
      render json: { message: "Group cannot be created" }, status: :bad_request
    end
  end

  def destroy
    begin
      group = Group.find(params[:id])
    rescue ActiveGraph::Node::Labels::RecordNotFound => e
      return render json: { message: "Group not found" }, status: :not_found
    end
    if group.manager != @current_user
      return render json: { message: "You must be the owner" }, status: :unauthorized
    end
    group.destroy
    if group.destroyed?
      render json: {
        id: group.id,
      }, status: :accepted
    else
      render json: { message: "Group cannot be destroyed" }, status: :bad_request
    end
  end

  private

  def group_params
    params.permit(:name, :description, :members_id)
  end
end
