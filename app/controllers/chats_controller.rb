class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = current_user.chats.includes(:health_goal, :spot).find(params[:id])
    @message = Message.new
    @spot = @chat.spot

    return unless @spot.present? && @chat.messages.none?

    @suggested_message =
      "How could #{@spot.name} help me work towards my goal of #{@chat.health_goal.name}?"
  end

  def create
    @health_goal = current_user.health_goals.find(params[:health_goal_id])
    @spot = Spot.find_by(id: params[:spot_id])

    # Two different flows share this action: "Chat about this goal" (from the
    # goal card on /coach) should continue the existing conversation for that
    # goal, but the general "Start a conversation" button explicitly wants a
    # fresh chat every time — it passes new_chat=true to opt out of reuse.
    @chat =
      if @spot.nil? && params[:new_chat] != "true"
        @health_goal.chats.find_by(user: current_user, spot: nil) ||
          @health_goal.chats.create(chat_params.merge(user: current_user))
      else
        @health_goal.chats.create(chat_params.merge(user: current_user, spot: @spot))
      end

    if @chat.persisted?
      redirect_to chat_path(@chat)
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
