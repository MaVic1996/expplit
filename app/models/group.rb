class Group
  include Neo4jNode

  property :name, type: String
  property :description, type: String, default: ''

  validates :name, presence: true

  has_many :in, :members, rel_class: :BelongsTo
  has_one :out, :manager, rel_class: :ManagedBy
end