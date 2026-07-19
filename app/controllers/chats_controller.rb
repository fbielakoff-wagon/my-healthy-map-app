class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new

    if params[:spot_id].present?
      @spot = Spot.find_by(id: params[:spot_id])

      if @spot
        @suggested_message =
          "How could #{@spot.name} help me work towards my goal of #{@chat.health_goal.name}?"
      end
    end
  end

  def create
    @health_goal = current_user.health_goals.find(params[:health_goal_id])
    @chat = @health_goal.chats.new(chat_params)
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat, spot_id: params[:spot_id])
    else
      redirect_to health_goal_path(@health_goal),
                  alert: "Could not start chat."
    end
  end

  private

  def chat_params
    params.fetch(:chat, {}).permit(:title)
  end
end
