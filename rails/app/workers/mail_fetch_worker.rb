class MailFetchWorker
  MAX_CHATS_TO_FETCH = 300

  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(user_id)
    user = User.find user_id#["$oid"]

    client = GmailClient.new
    client.authorize(user)

    number = 0
    token = nil

    begin
      threads, token = client.chats(token)

      number += threads.size

      threads.each do |thread|

        chat = user.chats.find_or_create_by(google_id: thread["id"]) do |record|
          record.snippet = thread["snippet"]
          record.history_id = thread["historyId"]
        end

        ChatMessagesFetchWorker.perform_async(chat.id)
      end

    end while (threads.present? && number < MAX_CHATS_TO_FETCH)
  end

end
