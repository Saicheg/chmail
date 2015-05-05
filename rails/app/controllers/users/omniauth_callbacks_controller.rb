class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2

    if user.present?
      update_user_credentials
    else
      create_user
    end

    sign_in(user)

    redirect_to root_url
  end

  def user
    @user ||= User.find_by(email: google_data.info.email)
  end

  def google_data
    @google_data ||= request.env["omniauth.auth"]
  end

  def create_user
    @user = User.create! do |fields|
      fields.email = google_data.info.email
      fields.password = SecureRandom.hex
      fields.password_confirmation = fields.password
      fields.token = google_data.credentials.token
      fields.refresh_token = google_data.credentials.refresh_token
      fields.expires_at = Time.at(google_data.credentials.expires_at)
      fields.uid = google_data.uid
      fields.name = google_data.info.name
      fields.first_name = google_data.info.first_name
      fields.last_name = google_data.info.last_name
      fields.image = google_data.info.image
      fields.gender = google_data.info.gender
    end
  end

  def update_user_credentials
    user.update_attributes! token: google_data.credentials.token,
                            refresh_token: google_data.credentials.refresh_token,
                            expires_at:  Time.at(google_data.credentials.expires_at)
  end

end
