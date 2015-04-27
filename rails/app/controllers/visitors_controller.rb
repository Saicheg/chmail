require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

class VisitorsController < ApplicationController
	def index
		@chats = GmailClient.new({
			:client_id => '70396743625-r21u11du4hs3935m75pncgbue4a0k1fo.apps.googleusercontent.com',
			:client_secret => 'Ije-VQxxQAh3y02xtfmZXjNW',
			:scope => ['https://mail.google.com/', 'profile'],
			:redirect_url => '/auth/google/callback',
			:host => 'localhost',
			:port => 3000
		}).gmail_chats.to_hash["threads"]
	end
end
