class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = current_user.chats.includes(:health_goal, :spot).find(params[:id])
    @message = Message.new
    @spot = @chat.spot

    return unless @spot.present? && @chat.messages.none?

    @suggested_message =
  "How could #{@spot.name} help me work towards this goal?"
  end

def create
  @health_goal = current_user.health_goals.find(params[:health_goal_id])
  @spot = Spot.find_by(id: params[:spot_id])

  @chat = @health_goal.chats.create(
    chat_params.merge(
      user: current_user,
      spot: @spot
    )
  )

  if @chat.persisted?
    redirect_to chat_path(@chat)
  else
    redirect_to health_goal_path(@health_goal),
                alert: "Could not start chat."
  end
end

  def update
  @chat = current_user.chats.find(params[:id])
  @health_goal = current_user.health_goals.find(
    params.require(:chat).fetch(:health_goal_id)
  )

  if @chat.update(health_goal: @health_goal)
    redirect_to chat_path(@chat)
  else
    redirect_to chat_path(@chat),
                alert: "Could not change the goal."
  end
end

  private

  def chat_params
    params.fetch(:chat, {}).permit(:title)
  end
end
