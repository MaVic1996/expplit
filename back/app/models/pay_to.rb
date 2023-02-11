class PayTo
  include Neo4jRelationship
  
  from_class :User
  to_class :User

  property :amount, type: BigDecimal
  property :group_id, type: String
end