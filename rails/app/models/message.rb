class Message
  include Mongoid::Document

  field :external_id, type: String
  field :text, type: String

  has_one :paricipant
  has_one :user
end
