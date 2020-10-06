class AddBasinsIdToAreaSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :area_searches, :basins_id, :string, array: true, default: []
  end
end
