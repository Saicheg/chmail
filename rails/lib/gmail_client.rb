require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'base64'
require 'mime'
include MIME

class GmailClient

  def initialize
    @client = Google::APIClient.new application_name: 'chMail',
                                   application_version: '1.0.0'

    @gmail = @client.discovered_api('gmail', 'v1')
  end

  def authorize(user)
    authorize = Signet::OAuth2::Client.new client_id: Rails.application.secrets.google_client_id,
                                         client_secret: Rails.application.secrets.google_client_secret,
                                         access_token: user.token

    @client.authorization = authorize
  end

  def chats(page_token = nil)
    params =  {'userId' => 'me'}

    params['pageToken'] = page_token if page_token.present?

    response = @client.execute api_method: @gmail.users.threads.list,
                               parameters: params
    data = response.data.to_hash

    [data["threads"], data["nextPageToken"]]
  end

  def messages(thread_id)
    response = @client.execute api_method: @gmail.users.threads.get,
                               parameters: { 'userId' => 'me', 'id' => thread_id }


    response.data.to_hash["messages"]
  end

  # def send_mail(params)
  #   encoded_body = Base64.encode64(params[:body])
  #   msg = Mail.new
  #   msg.date = Time.now
  #   msg.subject = 'Test Subject'
  #   msg.body = params[:body]
  #   msg.from = 'vladimir.hudnitsky@gmail.com'
  #   msg.to   = 'saicheg@gmail.com'
  #   begin
  #     result = @client.execute(
  #         :api_method => @gmail.users.messages.to_h['gmail.users.messages.send'],
  #         :body_object => {
  #             :raw => Base64.urlsafe_encode64(msg.to_s)
  #         },
  #         :parameters => {
  #             :userId => 'me',
  #         }
  #     )
  #     return result.data
  #   rescue ArgumentError => e
  #     @client.authorization = @flow.authorize
  #     auth = Auth.new(
  #         :access_token => @client.authorization.access_token,
  #         :id_token => @client.authorization.id_token,
  #         :code => @client.authorization.code
  #     )
  #     auth.upsert
  #     result = @client.execute(
  #         :api_method => @gmail.users.messages.to_h['gmail.users.messages.send'],
  #         :body_object => {
  #             :raw => Base64.urlsafe_encode64(msg.to_s)
  #         },
  #         :parameters => {
  #             :userId => 'me',
  #         }
  #     )
  #     return result.data
  #   end
  # end

end
