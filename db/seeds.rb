# db/seeds.rb
#
# Seeds "My Healthy Map" with real gyms, healthy food spots and
# wellness/recovery places in London and Munich, so you can test
# city + category filtering before wiring up a live Places API.
#
# Run with:
#   rails db:seed
# or, to wipe existing spots created by this seed user and reload:
#   rails db:seed:replant

puts "== Seeding My Healthy Map spots =="

# ---------------------------------------------------------------------------
# 1. Seed user (spots.user_id is required — attach all seed spots to one
#    system account so they're easy to find/remove later)
# ---------------------------------------------------------------------------
seed_user = User.find_or_create_by!(email: "seed@myhealthymap.com") do |u|
  u.name = "My Healthy Map"
  u.password = SecureRandom.hex(12) if u.respond_to?(:password=)
end

puts "Using seed user ##{seed_user.id} (#{seed_user.email})"

# ---------------------------------------------------------------------------
# 2. Spot data — category is one of: "food", "wellness", "fitness"
# ---------------------------------------------------------------------------
SPOTS = [
  # ---------------------------- LONDON — FITNESS ---------------------------
  { name: "Third Space Mayfair", category: "fitness", city: "London",
    address: "22 Clarges St, London W1J 5FA, UK",
    latitude: 51.5075814, longitude: -0.145922,
    description: "Premium gym with pool, sauna, reformer Pilates and PT sessions in the heart of Mayfair." },
  { name: "LIFT STUDIO LDN", category: "fitness", city: "London",
    address: "10 Lion Yard, Tremadoc Rd, London SW4 7NQ, UK",
    latitude: 51.4632248, longitude: -0.1315734,
    description: "Women-only strength training studio with small-group PT coaching in Clapham." },
  { name: "Third Space Soho", category: "fitness", city: "London",
    address: "67 Brewer St, London W1F 9US, UK",
    latitude: 51.5112699, longitude: -0.1357459,
    description: "Full-service gym with pool, classes, physio and boxing/kickboxing in Soho." },
  { name: "Topnotch Gyms Soho", category: "fitness", city: "London",
    address: "Dufour's Pl, London W1F 7SP, UK",
    latitude: 51.5136119, longitude: -0.1374895,
    description: "Spacious central London gym with reformer Pilates classes and day passes." },
  { name: "Third Space Wood Wharf", category: "fitness", city: "London",
    address: "14 Charter St, Canary Wharf Estate, London E14 5GZ, UK",
    latitude: 51.5031207, longitude: -0.0127336,
    description: "Modern Canary Wharf gym with a calm, premium training atmosphere." },
  { name: "City Athletic", category: "fitness", city: "London",
    address: "20 Palace St, London SW1E 5BA, UK",
    latitude: 51.4980448, longitude: -0.1405567,
    description: "Boutique gym near Victoria with modern equipment and personal training." },

  # ------------------------------ LONDON — FOOD -----------------------------
  { name: "Mildreds Soho", category: "food", city: "London",
    address: "45 Lexington St, Carnaby, London W1F 9AN, UK",
    latitude: 51.5130279, longitude: -0.1364023,
    description: "Long-running vegan/vegetarian restaurant known for global plant-based comfort food." },
  { name: "The Eternal Garden", category: "food", city: "London",
    address: "Unit 52 Skylines Village, London E14 9TS, UK",
    latitude: 51.4988931, longitude: -0.012919,
    description: "Fresh, health-forward breakfast and salad spot popular for pick-up orders." },
  { name: "Vantra", category: "food", city: "London",
    address: "5 Wardour St, London W1D 6PB, UK",
    latitude: 51.5106871, longitude: -0.1318651,
    description: "Sugar-free, gluten-free, dairy-free vegan restaurant in central London." },
  { name: "Mallow Borough Market", category: "food", city: "London",
    address: "1 Cathedral St, London SE1 9DE, UK",
    latitude: 51.5062513, longitude: -0.0904033,
    description: "Fully plant-based small-plates restaurant right by Borough Market." },
  { name: "Tendril - A (mostly) Vegan Kitchen & Bar", category: "food", city: "London",
    address: "5 Princes St, London W1B 2LF, UK",
    latitude: 51.5146122, longitude: -0.1427628,
    description: "Chef-led mostly-vegan kitchen with a seasonal, creative plant-based menu." },
  { name: "KIN Restaurant", category: "food", city: "London",
    address: "21A Foley St, London W1W 6DS, UK",
    latitude: 51.5193468, longitude: -0.1402485,
    description: "Highly-rated vegan restaurant in Fitzrovia known for bold flavours." },

  # ---------------------------- LONDON — WELLNESS ---------------------------
  { name: "Rebase", category: "wellness", city: "London",
    address: "1a St Vincent St, London W1U 4DA, UK",
    latitude: 51.5187955, longitude: -0.152065,
    description: "Recovery club with sauna, cold plunge, cryotherapy and HBOT circuits." },
  { name: "111CRYO - Cryotherapy London", category: "wellness", city: "London",
    address: "4th Floor, Harvey Nichols, London SW1X 7RJ, UK",
    latitude: 51.5016361, longitude: -0.1595297,
    description: "Whole-body cryotherapy and sports massage inside Harvey Nichols, Knightsbridge." },
  { name: "Cryohealth Southgate", category: "wellness", city: "London",
    address: "4 The Broadway, London N14 6PH, UK",
    latitude: 51.6327909, longitude: -0.1265095,
    description: "Cryotherapy and cold-air treatment clinic for pain relief and recovery." },
  { name: "Vidavii Mayfair", category: "wellness", city: "London",
    address: "58 S Molton St, London W1K 5SL, UK",
    latitude: 51.5135809, longitude: -0.1472326,
    description: "30-minute recovery circuit combining massage, lymphatic drainage, cryo and infrared sauna." },
  { name: "Apogii Clinic (Get A Drip)", category: "wellness", city: "London",
    address: "105 Westbourne Grove, London W2 4UW, UK",
    latitude: 51.5150744, longitude: -0.1934994,
    description: "IV drip and wellness clinic in Notting Hill with cryo facilities." },
  { name: "Ice Health Cryotherapy London", category: "wellness", city: "London",
    address: "237 Kensington High St, London W8 6SA, UK",
    latitude: 51.4991766, longitude: -0.1978034,
    description: "Cryotherapy, lymphatic drainage and recovery treatments in Kensington." },

  # ---------------------------- MUNICH — FITNESS ----------------------------
  { name: "Eternity Health Club", category: "fitness", city: "Munich",
    address: "Hohenzollernstraße 5, 80801 München, Germany",
    latitude: 48.1592353, longitude: 11.5841423,
    description: "Boutique fitness studio with premium equipment, classes and a smoothie bar." },
  { name: "The Good Gym For Her", category: "fitness", city: "Munich",
    address: "Amalienpassage, Amalienstraße 87-89, 80799 München, Germany",
    latitude: 48.1517196, longitude: 11.5781314,
    description: "English-language studio with yoga, barre, bootcamp and pilates classes." },
  { name: "MY100 München", category: "fitness", city: "Munich",
    address: "Buttermelcherstraße 21, 80469 München, Germany",
    latitude: 48.1321323, longitude: 11.5795204,
    description: "Community-focused gym with personal training and group classes." },
  { name: "EVO Fitness München Glockenbach", category: "fitness", city: "Munich",
    address: "Baaderstraße 80, 80469 München, Germany",
    latitude: 48.1283707, longitude: 11.5753654,
    description: "Modern, central gym with a wide range of free weights and machines." },
  { name: "Evolve Fitness Munich", category: "fitness", city: "Munich",
    address: "Sendlinger Str. 21, 80331 München, Germany",
    latitude: 48.1352659, longitude: 11.5707792,
    description: "English-speaking small-group training studio for strength and mobility." },
  { name: "Rare Form", category: "fitness", city: "Munich",
    address: "Schönfeldstraße 8, 80539 München, Germany",
    latitude: 48.1458258, longitude: 11.5800944,
    description: "Innovative small-group training studio with a strong community feel." },

  # ------------------------------ MUNICH — FOOD -----------------------------
  { name: "JOY OF MADHU München", category: "food", city: "Munich",
    address: "Holzstraße 19, 80469 München, Germany",
    latitude: 48.1296384, longitude: 11.5678788,
    description: "Wholefood cafe known for grain bowls and gluten-free sweet potato bread." },
  { name: "Max Pett... Das vegane Restaurant", category: "food", city: "Munich",
    address: "Pettenkoferstraße 8, 80336 München, Germany",
    latitude: 48.134364, longitude: 11.563783,
    description: "Fully vegan restaurant reinventing Bavarian classics with plant-based ingredients." },
  { name: "A Little Lost", category: "food", city: "Munich",
    address: "Lämmerstraße 6, 80335 München, Germany",
    latitude: 48.1422876, longitude: 11.5589474,
    description: "All-vegan cafe near the main station, great for coffee and a healthy bite." },
  { name: "Soy Vegan München", category: "food", city: "Munich",
    address: "Theresienstraße 93, 80333 München, Germany",
    latitude: 48.1520382, longitude: 11.5605554,
    description: "Popular vegan Asian restaurant known for tofu dishes and fresh flavours." },
  { name: "Secret Garden", category: "food", city: "Munich",
    address: "Heiliggeiststraße 2 A, 80331 München, Germany",
    latitude: 48.1356704, longitude: 11.5775227,
    description: "Vegan sushi and bowls restaurant with a lively atmosphere near Marienplatz." },
  { name: "bodhi | München", category: "food", city: "Munich",
    address: "Ligsalzstraße 23, 80339 München, Germany",
    latitude: 48.1356573, longitude: 11.5426053,
    description: "All-vegan Bavarian restaurant serving plant-based schnitzel and Kaiserschmarrn." },

  # ---------------------------- MUNICH — WELLNESS ---------------------------
  { name: "Cryo iX", category: "wellness", city: "Munich",
    address: "Meglingerstraße 62, 81477 München, Germany",
    latitude: 48.08923, longitude: 11.5069,
    description: "Cryochamber and lymphatic massage studio with a cozy, personal feel." },
  { name: "Session Labs", category: "wellness", city: "Munich",
    address: "Fürstenstraße 11/Hinterhaus, 80333 München, Germany",
    latitude: 48.1466745, longitude: 11.5769183,
    description: "Barre, pilates and strength studio with sauna and cold plunge recovery area." },
  { name: "Deevari Spa am Goetheplatz", category: "wellness", city: "Munich",
    address: "Häberlstraße 21, 80337 München, Germany",
    latitude: 48.1270062, longitude: 11.558655,
    description: "Asian-inspired spa specialising in deep tissue and Thai-style massage." },
  { name: "Relax & Heal – Massage München", category: "wellness", city: "Munich",
    address: "Gmunder Str. 11, 81379 München, Germany",
    latitude: 48.0972053, longitude: 11.5311202,
    description: "Massage studio focused on relaxation and targeted muscle tension relief." },
  { name: "Premium Float Schwabing", category: "wellness", city: "Munich",
    address: "Feilitzschstraße 26, 80802 München, Germany",
    latitude: 48.1607552, longitude: 11.5908826,
    description: "Float therapy and massage studio, open seven days a week." },
  { name: "MySpa – Your Personal Wellzone", category: "wellness", city: "Munich",
    address: "Maria-Probst-Straße 22, 80939 München, Germany",
    latitude: 48.1922839, longitude: 11.5984233,
    description: "Private sauna and wellness suites bookable by the hour, digitally controlled." },
].freeze

# ---------------------------------------------------------------------------
# 3. Create (idempotent — safe to run multiple times)
# ---------------------------------------------------------------------------
created, skipped = 0, 0

SPOTS.each do |attrs|
  spot = Spot.find_or_initialize_by(name: attrs[:name], city: attrs[:city])

  if spot.persisted?
    skipped += 1
    next
  end

  spot.assign_attributes(attrs.merge(user: seed_user))
  spot.save!
  created += 1
end

puts "Done. Created #{created} spots, skipped #{skipped} already-existing spots."
puts "Cities: #{SPOTS.map { |s| s[:city] }.uniq.join(', ')}"
puts "Categories: #{SPOTS.map { |s| s[:category] }.uniq.join(', ')}"

# Ruth's test spots (from the favourites feature branch) — kept as-is
# alongside the main seed data rather than dropped while fixing a merge conflict.
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
