require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'rubygems'
require 'active_support'
require 'rails/mongoid'
require 'rails/all'
require 'base64'
require 'mime'
include MIME

class GmailClient

  def initialize(options)
    @client = Google::APIClient.new(
        :application_name => 'chMail',
        :application_version => '1.0.0'
    )
    @gmail = @client.discovered_api('gmail', 'v1')

    # Load client secrets from your client_secrets.json.
    @flow = GoogleAuthClient.new(options)
    db_creds = Auth.find_by(:id_token => 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImQzZGI2ZjFiZDFhMGIxZTg0YjZlNzBhZjVlMzM4YzViYmNjOTg3OWMifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwic3ViIjoiMTExMDcwNTIzOTcxMDk4MTUzMTg3IiwiYXpwIjoiNzAzOTY3NDM2MjUtcjIxdTExZHU0aHMzOTM1bTc1cG5jZ2J1ZTRhMGsxZm8uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdF9oYXNoIjoieHpLZVJRTC1CeWpmY2Roay1wUGtYUSIsImF1ZCI6IjcwMzk2NzQzNjI1LXIyMXUxMWR1NGhzMzkzNW03NXBuY2didWU0YTBrMWZvLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiaWF0IjoxNDMwMDYwNTAwLCJleHAiOjE0MzAwNjQxMDB9.caKMZTb1YH4PFL1V8ZYp9nGaWM6lXhs39HDpW1HIaTNkqjkqrIgQwhVnkhvJWamGMsfMVKVSC9JnSF7HwmgP7GI9bafwbf7HdMnsg5LobTMew-nZzLSCngUO7RsgfPhEuBfN8DzNHbfcinyC0FOpdOXbwFrgdIGYJpUpIEkeqOc')
    saved_credentials = {
        :access_token => db_creds.access_token,
        :authorization_uri => "https://accounts.google.com/o/oauth2/auth",
        :client_id => "70396743625-r21u11du4hs3935m75pncgbue4a0k1fo.apps.googleusercontent.com",
        :client_secret => "Ije-VQxxQAh3y02xtfmZXjNW",
        :id_token => db_creds.id_token,
        :redirect_uri => "http://localhost:3000/auth/google/callback",
        :scope => ["https://mail.google.com/", "profile"],
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :code => db_creds.code
    }
    @client.authorization = !saved_credentials ? @flow.authorize : Signet::OAuth2::Client.new(saved_credentials)
    auth_model = Auth.new(
        :access_token => @client.authorization.access_token,
        :id_token => @client.authorization.id_token,
        :code => @client.authorization.code

    )
    auth_model.upsert
  end


  def gmail_chats
    begin
      result = @client.execute(
          :api_method => @gmail.users.threads.list,
          :parameters => {'userId' => 'me'}
      )
      return result.data
    rescue ArgumentError => e
      @client.authorization = @flow.authorize
      auth = Auth.new(
          :access_token => @client.authorization.access_token,
          :id_token => @client.authorization.id_token,
          :code => @client.authorization.code
      )
      auth.upsert
      result = @client.execute(
          :api_method => @gmail.users.threads.list,
          :parameters => {'userId' => 'me'}
      )
      binding.pry
      return result.data
    end
  end

  def send_mail(params)
    encoded_body = Base64.encode64(params[:body])
    msg = Mail.new
    msg.date = Time.now
    msg.subject = 'Test Subject'
    msg.body = params[:body]
    msg.from = 'vladimir.hudnitsky@gmail.com'
    msg.to   = 'saicheg@gmail.com'
    begin
      result = @client.execute(
          :api_method => @gmail.users.messages.to_h['gmail.users.messages.send'],
          :body_object => {
              :raw => Base64.urlsafe_encode64(msg.to_s)
          },
          :parameters => {
              :userId => 'me',
          }
      )
      return result.data
    rescue ArgumentError => e
      @client.authorization = @flow.authorize
      auth = Auth.new(
          :access_token => @client.authorization.access_token,
          :id_token => @client.authorization.id_token,
          :code => @client.authorization.code
      )
      auth.upsert
      result = @client.execute(
          :api_method => @gmail.users.messages.to_h['gmail.users.messages.send'],
          :body_object => {
              :raw => Base64.urlsafe_encode64(msg.to_s)
          },
          :parameters => {
              :userId => 'me',
          }
      )
      return result.data
    end
  end

end
