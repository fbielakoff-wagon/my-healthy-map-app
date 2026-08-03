class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_spot

  def create
    @review = current_user.reviews.find_or_initialize_by(spot: @spot)
    @review.assign_attributes(review_params)

    if @review.save
      redirect_to @spot, notice: "Thanks for your review!"
    else
      redirect_to @spot, alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
