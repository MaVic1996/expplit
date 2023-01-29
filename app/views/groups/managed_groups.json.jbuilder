

json.array! @groups do |group|
  json.id group.id
  json.name group.name
  json.created_at group.created_at.strftime("%d-%m-%Y")
end