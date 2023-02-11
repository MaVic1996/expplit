
json.id @group.id
json.name @group.name

json.manager_id @manager.id

json.member_count @members.count
json.members(@members) do |member|
  json.(member, :id, :name)
end