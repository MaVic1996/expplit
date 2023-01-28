class BelongsTo
  include Neo4jRelationship

  from_class :Member
  to_class :Group
end