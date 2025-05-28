class MessagesController < ApplicationController
  def index
    messages = Message.all
    render json: messages
  end

  def create
    message = Message.new(message_params)
    if message.save
      render json: message, status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.permit(:user_id, :content)
  end
end
