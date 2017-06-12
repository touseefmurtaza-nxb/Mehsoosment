class CreateStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :statuses do |t|
      t.string :status_text
      t.integer :user_id
      t.datetime :expires_at

      t.timestamps
    end
  end
end
