class ChangeColumnStatusToAvailable < ActiveRecord::Migration[6.0]
  def change
    rename_column :areas, :status, :available?
  end
end
