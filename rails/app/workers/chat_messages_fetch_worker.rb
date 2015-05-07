class ChatMessagesFetchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(chat_id)
    chat = Chat.find(chat_id["$oid"])
    user = chat.user

    client = GmailClient.new
    client.authorize(user)

    messages = client.messages(chat.google_id)

    messages.each do |message|
      headers = message["payload"]["headers"]

      # text = if message["payload"]["parts"].present?
      #          parts = message["payload"]["parts"]
      #          parts.map { |part| Base64.decode64(part["body"]["data"]) }.join
      #        else
      #          Base64.decode64(message["payload"]["body"]["data"])
      #        end

      text = if message["payload"]["parts"].present?
               parts = message["payload"]["parts"]
               parts.map { |part| part["body"]["data"] }.join
             else
               message["payload"]["body"]["data"]
             end

      chat.messages.create google_id: message["id"],
                           from: header_value(headers, "From"),
                           to: header_value(headers, "To"),
                           subject: header_value(headers, "Subject"),
                           text: text,
                           send_date: header_value(headers, "Subject")
    end
  end

  def header_value(headers, name)
    headers.find { |h| h["name"] == name }["value"]
  end

end
