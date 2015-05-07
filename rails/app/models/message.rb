class Message
  include Mongoid::Document

  field :google_id, type: String
  field :from,      type: String
  field :to,        type: String
  field :subject,   type: String
  field :text,      type: String
  field :send_date, type: DateTime

  has_one :paricipant
  has_one :user
end
