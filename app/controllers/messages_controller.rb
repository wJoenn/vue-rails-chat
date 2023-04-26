class MessagesController < ApplicationController
  before_action :set_chatroom

  def index
    render json: Message.where(chatroom: @chatroom), status: :ok
  end

  def create
    message = Message.new(message_params)
    message.chatroom = @chatroom
    message.user = current_user
    message.username = current_user.username

    if message.save
      ChatroomChannel.broadcast_to(@chatroom, message)

      head :ok
    else
      render json: message.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find_by(id: params[:chatroom_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
