class MailFetchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(user_id)
    user = User.find(user_id["$oid"])
  end

end
