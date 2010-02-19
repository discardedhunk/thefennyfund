class RemoveProductGroups < ActiveRecord::Migration
  def self.up
    drop_table :product_groups
  end

  def self.down
  end
end
