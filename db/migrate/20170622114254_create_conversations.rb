class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.integer :user_id
      t.integer :room_id
      t.integer :connection_id

      t.timestamps
    end
  end
end
