class AddDefaultValueToTradeStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_default :trades, :status, from: nil, to: "Proposta"
  end
end
