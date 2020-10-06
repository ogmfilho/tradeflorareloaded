class AddStatesIdToAreaSearches < ActiveRecord::Migration[6.0]
  def change
    add_column :area_searches, :states_id, :string, array: true, default: []
  end
end
