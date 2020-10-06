class AddCitiesIdToAreaSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :area_searches, :cities_id, :string, array: true, default: []
  end
end
