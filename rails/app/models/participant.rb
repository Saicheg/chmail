class Participant
  include Mongoid::Document

  field :email, type: String
  field :name, type: String

  belongs_to :user
end
