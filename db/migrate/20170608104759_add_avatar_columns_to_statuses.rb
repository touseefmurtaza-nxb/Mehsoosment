class AddAvatarColumnsToStatuses < ActiveRecord::Migration[5.0]
  def up
    add_attachment :statuses, :image
  end

  def down
    remove_attachment :statuses, :image
  end
end
