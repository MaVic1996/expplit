class ManagedBy
  include Neo4jRelationship

  from_class :Group
  to_class :User
end
