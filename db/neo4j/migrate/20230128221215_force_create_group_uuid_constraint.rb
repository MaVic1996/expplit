class ForceCreateGroupUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Group, :uuid, force: true
  end

  def down
    drop_constraint :Group, :uuid
  end
end
