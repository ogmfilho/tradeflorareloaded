class AddDefaultValueToAreaAvailable < ActiveRecord::Migration[6.0]
  def change
    change_column_default :areas, :available?, from: nil, to: true
  end
end
