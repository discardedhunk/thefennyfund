class AddTotalDiscountToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :total, :decimal, :precision => 8, :scale => 2
    add_column :orders, :discount, :integer
  end

  def self.down
    remove_column :orders, :total, :decimal
    remove_column :orders, :discount, :integer
  end
end
