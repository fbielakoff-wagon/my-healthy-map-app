class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_welcome_modal_flag

  private

  def set_welcome_modal_flag
    @show_welcome_modal = user_signed_in? && !session[:welcome_modal_shown]
    session[:welcome_modal_shown] = true if @show_welcome_modal
  end
end
