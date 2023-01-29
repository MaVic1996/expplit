

json.(@group, :id, :name, :description)

json.creation do
  json.manager @group.manager.email
  json.created_at @group.created_at.strftime("%d-%m%-Y")
end

json.member_count @group.members.count
json.members(@group.members) do |member|
  json.(member, :name)
end