class AddIndexPpTxIdUniqueToOrders < ActiveRecord::Migration
  def self.up
    change_column :orders, :pp_tx_id, :string, :unique => true
    add_index :orders, :pp_tx_id
  end

  def self.down
    change_column :orders, :pp_tx_id, :string, :unique => false
    remove_index :orders, :pp_tx_id
  end
end
