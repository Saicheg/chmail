class User
  include Mongoid::Document

  field :email, type: String
  field :name, type: String

  has_one :participant
  has_one :auth
end
