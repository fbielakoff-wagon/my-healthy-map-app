module SpotsHelper
  CATEGORY_EMOJIS = {
    "food" => "🥗",
    "fitness" => "💪",
    "wellness" => "🧘",
    "drinks" => "🍹"
  }.freeze

  def category_emoji(category)
    CATEGORY_EMOJIS[category.to_s] || "📍"
  end

  def star_rating(rating)
    return content_tag(:span, "No ratings yet", class: "star-rating star-rating--empty") if rating.blank?

    full_stars = rating.round

    content_tag(:span, class: "star-rating") do
      (1..5).map do |i|
        content_tag(:span, "★", class: i <= full_stars ? "star star--filled" : "star")
      end.join.html_safe
    end
  end
end
