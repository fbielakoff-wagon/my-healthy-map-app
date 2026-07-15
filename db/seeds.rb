puts "Cleaning database..."

Favourite.destroy_all
Spot.destroy_all
User.destroy_all

puts "Creating users..."

ruth = User.create!(
  email: "ruth@example.com",
  password: "password",
  name: "Ruth"
)

puts "Creating spots..."

Spot.create!(
  name: "Green Table",
  category: "food",
  address: "10 Test Street",
  city: "London",
  user: ruth
)

Spot.create!(
  name: "City Strength",
  category: "fitness",
  address: "20 Test Road",
  city: "London",
  user: ruth
)

Spot.create!(
  name: "Calm Studio",
  category: "wellness",
  address: "30 Test Lane",
  city: "London",
  user: ruth
)

puts "Done!"
