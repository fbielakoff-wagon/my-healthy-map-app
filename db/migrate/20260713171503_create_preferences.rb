class CreatePreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :preferences do |t|
      t.string :categories
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
