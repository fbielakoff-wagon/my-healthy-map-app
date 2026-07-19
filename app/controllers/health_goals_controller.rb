class HealthGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_health_goal, only: %i[show edit update destroy]

  def index
    @health_goals = current_user.health_goals
  end

  def show
  end

  def new
    @health_goal = current_user.health_goals.new
  end

  def create
    @health_goal = current_user.health_goals.new(health_goal_params)

    @health_goal.system_prompt = <<~PROMPT
      You are a personal health coach helping a user achieve a specific goal.

      Goal: #{@health_goal.name}
      Category: #{@health_goal.module}
      Details: #{@health_goal.content}

      Be encouraging, specific and practical.
      Ask clarifying questions when needed.
      Keep responses concise and actionable.
    PROMPT

    if @health_goal.save
      redirect_to health_goal_path(@health_goal)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @health_goal.update(health_goal_params)
      @health_goal.update(system_prompt: build_system_prompt(@health_goal))
      redirect_to health_goal_path(@health_goal)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @health_goal.destroy
    redirect_to health_goals_path
  end

  private

  def set_health_goal
    @health_goal = current_user.health_goals.find(params[:id])
  end

  def health_goal_params
    params.require(:health_goal).permit(:name, :module, :content)
  end

  def build_system_prompt(health_goal)
    <<~PROMPT
      You are a personal health coach helping a user achieve a specific goal.

      Goal: #{health_goal.name}
      Category: #{health_goal.module}
      Details: #{health_goal.content}

      Be encouraging, specific and practical.
      Ask clarifying questions when needed.
      Keep responses concise and actionable.
    PROMPT
  end
end
