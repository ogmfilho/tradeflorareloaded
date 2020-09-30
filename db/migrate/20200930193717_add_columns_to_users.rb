class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :document_number, :string
    add_column :users, :phone_number, :string
    add_column :users, :address, :string
    add_reference :users, :city, null: false, foreign_key: true
  end
end
