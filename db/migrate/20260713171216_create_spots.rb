class CreateSpots < ActiveRecord::Migration[8.1]
  def change
    create_table :spots do |t|
      t.string :name
      t.text :description
      t.string :category
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :city
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
