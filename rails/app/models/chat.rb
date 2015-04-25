class Chat
  include Mongoid::Document

  field :subject, type: String
  field :snippet, type: String
  field :history_id, type: String

   embeds_many :messages
   has_many :participants
end
