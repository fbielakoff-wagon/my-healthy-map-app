# db/migrate/XXXXXX_add_sourcing_to_spots.rb
class AddSourcingToSpots < ActiveRecord::Migration[8.1]
  def change
    add_column :spots, :external_id,  :string
    add_column :spots, :source,       :string, default: "seed", null: false
    add_column :spots, :subcategory,  :string
    add_column :spots, :fetched_at,   :datetime
    add_column :spots, :cache_tile,   :string

    add_index :spots, :external_id, unique: true
    add_index :spots, [:cache_tile, :category]
    add_index :spots, :source
  end
end
