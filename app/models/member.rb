class Member
  include Neo4jNode

  property :name, type: String
  property :email, type: String

  validates :name, presence: true
  validates :email, presence: true

  has_many :out, :groups, rel_class: :BelongsTo
end