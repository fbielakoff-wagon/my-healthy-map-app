module HealthyCategories
  CANONICAL = {
    "food" => %w[
      vegan_restaurant
      vegetarian_restaurant
      health_food_store
      organic_grocery
      juice_bar
      salad_bar
      smoothie_shop
      poke_restaurant
      farmers_market
      cafe
    ],
    "fitness" => %w[
      gym
      fitness_center
      yoga_studio
      pilates_studio
      martial_arts_school
      boxing_gym
      climbing_gym
      swimming_pool
      sports_club
      dance_studio
      tennis_court
      personal_trainer
    ],
    "wellness" => %w[
      spa
      massage
      sauna
      thermal_bath
      wellness_center
      meditation_center
      physiotherapist
      chiropractor
      acupuncture_clinic
      beauty_salon
      health_spa
    ]
  }.freeze

  KEYWORDS = {
    "food" => [
      "protein bowl", "acai bowl", "plant based restaurant",
      "gluten free bakery", "matcha cafe", "kombucha bar",
      "wholefoods", "organic food", "meal prep delivery"
    ],
    "fitness" => [
      "crossfit box", "hyrox gym", "reformer pilates",
      "spin studio", "calisthenics park", "barre studio",
      "F45", "padel club", "bootcamp"
    ],
    "wellness" => [
      "cryotherapy", "ice bath", "contrast therapy",
      "float tank", "infrared sauna", "hammam",
      "osteopath", "sports massage", "sound bath",
      "breathwork studio", "red light therapy", "IV drip clinic"
    ]
  }.freeze

  def self.all_for(category)     = CANONICAL.fetch(category, [])
  def self.keywords_for(category) = KEYWORDS.fetch(category, [])
end
