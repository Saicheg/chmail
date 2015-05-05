class User
  include Mongoid::Document

  devise :database_authenticatable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Omniauthable
  field :token,              type: String
  field :refresh_token,      type: String
  field :expires_at,         type: Time

  field :uid,                type: String
  field :name,               type: String
  field :first_name,         type: String
  field :last_name,          type: String
  field :image,              type: String
  field :gender,             type: String
end
