class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.text :body
      t.integer :rating
      t.references :user, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
