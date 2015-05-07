class ChatsController < ActionController::Base
  def index
    @chats = current_user.chats
  end
end
