class AddPpTxIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :pp_tx_id, :string
  end

  def self.down
    remove_column :orders, :pp_tx_id
  end
end
