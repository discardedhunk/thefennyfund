class AddCategoryGroupToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :category_id, :integer
    add_column :products, :group_id, :integer
  end

  def self.down
    remove_column :products, :category_id, :integer
    remove_column :products, :group_id, :integer
  end
end
