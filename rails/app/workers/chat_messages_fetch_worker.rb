class ChatMessagesFetchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(chat_id)
    chat = Chat.find(chat_id)
    user = chat.user

    client = GmailClient.new
    client.authorize(user)

    number = 0
    token = nil

    messages = client.messages(chat.google_id)

    messages.each do |message|
      headers = message["payload"]["headers"]
      text = message["payload"]["parts"].map { |part| Base64.decode64(part["body"]["data"]) }.join

      chat.messages.create google_id: message["14d0e7ffac024254"],
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
