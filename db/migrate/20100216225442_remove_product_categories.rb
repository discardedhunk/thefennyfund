class RemoveProductCategories < ActiveRecord::Migration
  def self.up
    drop_table :product_categories
  end

  def self.down
  end
end
