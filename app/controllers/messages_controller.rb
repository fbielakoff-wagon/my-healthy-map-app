class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      ruby_llm_chat.with_instructions(personalised_system_prompt)

      @chat.messages
           .order(:created_at)
           .where.not(id: @message.id)
           .each do |msg|
        ruby_llm_chat.add_message(
          role: msg.role.to_sym,
          content: msg.content
        )
      end

      response = ruby_llm_chat.ask(@message.content)

      @chat.messages.create!(
        role: "assistant",
        content: response.content
      )

      maybe_generate_chat_title

      redirect_to chat_path(@chat)
    else
      redirect_to chat_path(@chat), alert: "Could not send message."
    end
  end

  private

  def message_params
    params.fetch(:message, {}).permit(:content, :attachment)
  end

  def personalised_system_prompt
    preferred_categories =
      current_user.preference&.categories.presence ||
      "No preferred categories selected."

    favourite_spots =
      current_user.favourite_spots.map do |spot|
        "- #{spot.name}, #{spot.city}, #{spot.category}"
      end

    favourites_text =
      if favourite_spots.any?
        favourite_spots.join("\n")
      else
        "No favourite spots saved."
      end

    <<~PROMPT
      #{@chat.health_goal.system_prompt}

      Additional information from My Healthy Map:

      Preferred categories:
      #{preferred_categories}

      Favourite places:
      #{favourites_text}

      Use this information when it is relevant to the user's goal.

      Do not invent information about places, services or the user.
      If the available information is insufficient, ask a concise clarifying question.
    PROMPT
  end

  def maybe_generate_chat_title
    return if @chat.title.present?
    return unless @chat.messages.count >= 3


  end
end
