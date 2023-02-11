class BelongsTo
  include Neo4jRelationship

  from_class :User
  to_class :Group
end
