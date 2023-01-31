

json.(@user, :id, :name, :email, :created_at)

json.managed_groups(@user.managed_groups) do |group|
  json.(group, :id, :name)
  json.member_count group.members.count
end