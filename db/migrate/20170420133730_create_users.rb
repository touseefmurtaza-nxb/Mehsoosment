class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :pin
      t.boolean :verified
      t.string :uuid
      t.datetime :expires_at
      t.string :f_name
      t.string :l_name
      t.string :email
      t.boolean :notification, :default => true

      t.timestamps
    end
  end
end
