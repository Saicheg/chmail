require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/file_storage'
require 'json'
CREDENTIAL_STORE_FILE = "#{$0}-oauth2.json"
client = Google::APIClient.new(
      :application_name => 'Ruby Gmail sample',
      :application_version => '1.0.0')

user_credentials = {"access_token" =>
  "ya29.YQHVOmxzzigY65_CxvuNJZPyMhljp484ZejjYGYn_ZqnYKm2wqkfZKuM8Ie17Ajf0W3cHcp2J5AqNQ",
"authorization_uri" =>
  "https://accounts.google.com/o/oauth2/auth",
"client_id" =>
  "279891115125-n6pv7pfnnba9qj7suep5nunssmcbpbll.apps.googleusercontent.com",
"client_secret" => "qljaSuq9nFHSwJY7OnCGrtIQ",
"redirect_uri" =>
  "http://localhost:4567/oauth2callback",
"refresh_token" => "1/5DuR_5N65FA110_aniIw7gGbSseQ2d6ZkFP9o8JRTod90RDknAdJa_sgfheVM0XT",
"token_credential_uri" =>
  "https://accounts.google.com/o/oauth2"}

file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
if file_storage.authorization.nil?
  client_secrets = Google::APIClient::ClientSecrets.new({
  "web" => {
    "client_id": "279891115125-n6pv7pfnnba9qj7suep5nunssmcbpbll.apps.googleusercontent.com",
    "client_secret": "qljaSuq9nFHSwJY7OnCGrtIQ",
    "redirect_uris": ["http://localhost:4567"],
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://accounts.google.com/o/oauth2/token"
  }
}) 
  client.authorization = client_secrets.to_authorization
  client.authorization.scope = ['https://mail.google.com/', 'profile']
else
  client.authorization = file_storage.authorization
end

gmail = client.discovered_api('gmail', 'v1')

file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
file_storage.write_credentials(user_credentials)

result = client.execute(:api_method => gmail.users.messages.list,
                              :parameters => {userId: 'me'},
                              :authorization => user_credentials)
puts result.data.to_json