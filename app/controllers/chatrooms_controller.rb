class ChatroomsController < ApplicationController
  def index
    render json: Chatroom.all, status: :ok
  end
end
