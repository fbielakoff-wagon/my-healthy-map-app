class CoachController < ApplicationController
  before_action :authenticate_user!

  def index
    @health_goals = current_user.health_goals.order(created_at: :desc)
    @active_goal = @health_goals.first

    @recent_chats = current_user.chats
                                .includes(:health_goal, :spot)
                                .order(updated_at: :desc)
                                .limit(5)
  end
end
