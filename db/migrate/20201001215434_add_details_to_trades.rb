class AddDetailsToTrades < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :details, :string
  end
end
