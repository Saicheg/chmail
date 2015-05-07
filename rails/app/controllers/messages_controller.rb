class MessagesController < ActionController::Base
  def index
    @chat = current_user.chats.find(params[:chat_id])
  end
end
