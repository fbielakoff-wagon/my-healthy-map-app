class AddSpotToChats < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :spot, null: true, foreign_key: true
  end
end
