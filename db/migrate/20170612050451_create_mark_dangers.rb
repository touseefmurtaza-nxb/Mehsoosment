class CreateMarkDangers < ActiveRecord::Migration[5.0]
  def change
    create_table :mark_dangers do |t|
      t.float :latitude
      t.float :longitude
      t.integer :user_id
      t.integer :mark_type

      t.timestamps
    end
  end
end
