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
end
