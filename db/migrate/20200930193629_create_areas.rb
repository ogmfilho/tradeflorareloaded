class CreateAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :areas do |t|
      t.string :description
      t.string :coordinates
      t.float :extension
      t.boolean :status
      t.float :latitude
      t.float :longitude
      t.string :address
      t.references :cities, null: false, foreign_key: true
      t.references :basin, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
