class CreateAreaSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :area_searches do |t|
      t.string :keywords
      t.integer :max_extension
      t.integer :min_extension
      t.integer :basin_id
      t.integer :city_id
      t.integer :state_id

      t.timestamps
    end
  end
end
