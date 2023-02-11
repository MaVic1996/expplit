module Neo4jRelationship
  extend ActiveSupport::Concern

  include ActiveGraph::Relationship
  include ActiveGraph::Timestamps
end
