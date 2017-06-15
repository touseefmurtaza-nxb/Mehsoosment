class CreateFeatureCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :feature_codes do |t|
      t.string :code
      t.integer :feature_id

      t.timestamps
    end
  end
end
