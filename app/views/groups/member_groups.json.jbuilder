

json.array! @groups do |group|
  json.id group.id
  json.name group.name
  json.creator group.manager, :email
end