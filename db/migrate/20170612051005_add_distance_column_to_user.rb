class AddDistanceColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :distance, :float, default: 20.0
  end
end
