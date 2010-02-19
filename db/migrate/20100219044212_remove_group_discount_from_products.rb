class RemoveGroupDiscountFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :grouping
    remove_column :products, :category
  end

  def self.down
    add_column :products, :category, :string
    add_column :products, :grouping, :string
  end
end
