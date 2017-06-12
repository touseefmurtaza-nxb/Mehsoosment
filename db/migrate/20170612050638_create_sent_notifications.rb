class CreateSentNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :sent_notifications do |t|
      t.integer :user_id
      t.integer :marker_id

      t.timestamps
    end
  end
end
