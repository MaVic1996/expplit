module Neo4jNode
  extend ActiveSupport::Concern

  include ActiveGraph::Node
  include ActiveGraph::Timestamps
end
