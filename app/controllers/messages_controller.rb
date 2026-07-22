class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"
    if @message.save
      begin
        ruby_llm_chat = RubyLLM.chat(model: ENV.fetch("GITHUB_MODELS_MODEL", "gpt-4o-mini"))
        ruby_llm_chat.with_instructions(personalised_system_prompt)

        @chat.messages
             .order(:created_at)
             .where.not(id: @message.id)
             .each do |msg|
          ruby_llm_chat.add_message(role: msg.role.to_sym, content: msg.content)
        end

        response = ruby_llm_chat.ask(@message.content)

        @chat.messages.create!(role: "assistant", content: response.content)
        maybe_generate_chat_title

        redirect_to chat_path(@chat)
      rescue StandardError => e
        Rails.logger.error("RubyLLM error: #{e.class} - #{e.message}")
        # A flash alert here would never be seen — this request is scoped to the
        # chat_widget turbo frame, and the flash markup lives outside that frame
        # in the layout, so it silently never renders. Show the failure as a
        # normal message bubble instead, which is inside the frame either way.
        @chat.messages.create!(
          role: "assistant",
          content: "Sorry, I couldn't get a response just now. Please try again in a moment."
        )
        redirect_to chat_path(@chat)
      end
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

    current_spot_text =
      if @chat.spot.present?
        spot = @chat.spot

        <<~SPOT
          Name: #{spot.name}
          Category: #{spot.category}
          Description: #{spot.description}
          Address: #{spot.address}
          City: #{spot.city}
        SPOT
      else
        "This conversation was not started from a particular spot."
      end

    <<~PROMPT
      #{@chat.health_goal.system_prompt}

      Additional information from My Healthy Map:

      The user's current health goal:
      #{@chat.health_goal.name}

      Preferred categories:
      #{preferred_categories}

      Favourite places:
      #{favourites_text}

      Current spot being discussed:
      #{current_spot_text}

      When a current spot is provided, directly explain how it could support the
      user's health goal. Give practical, realistic suggestions based only on the
      supplied information.

      Keep the response supportive, concise and actionable.

      Do not invent opening hours, facilities, prices, accessibility information,
      services or other facts that have not been provided.

      If essential information is missing, say what is unknown or ask one concise
      clarifying question.
    PROMPT
  end

  def maybe_generate_chat_title
    return if @chat.title.present?
    return unless @chat.messages.count >= 3
  end
end
