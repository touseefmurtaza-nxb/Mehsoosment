class CreateUserCameraLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_camera_locations do |t|
      t.float :latitude
      t.float :longitude
      t.integer :user_id

      t.timestamps
    end
  end
end
