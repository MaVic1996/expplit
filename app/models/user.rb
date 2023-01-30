class User
  include Neo4jNode
  include ActiveModel::SecurePassword

  has_secure_password

  property :name, type: String
  property :email, type: String
  property :password, type: String
  property :password_digest, type: String

  validates :name, presence: true
  validates :password, presence: true

  has_many :out, :groups, rel_class: :BelongsTo
  has_many :in, :managed_groups, rel_class: :ManagedBy
end