class Auth
  include Mongoid::Document

  field :access_token, type: String
  field :id_token, type: String
  field :code, type: String

  belongs_to :user
end