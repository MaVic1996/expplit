class Group
  include Neo4jNode

  property :name, type: String
  property :description, type: String, default: ''

  validates :name, presence: true

  has_many :in, :users, rel_class: :BelongsTo
end