class User
  include Mongoid::Document

  field :email, type: String
  field :name, type: String
end
