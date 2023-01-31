class User
  include Neo4jNode
  include ActiveModel::SecurePassword

  has_secure_password

  property :name, type: String
  property :email, type: String
  property :password_digest, type: String
  property :logged_in_before, type: Boolean, default: true

  validates_uniqueness_of :email
  validates :name, presence: true
  validates :email, presence: true

  has_many :out, :groups, rel_class: :BelongsTo
  has_many :in, :managed_groups, rel_class: :ManagedBy
end