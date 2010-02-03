class AddGroupToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :group, :string
  end

  def self.down
    remove_column :products, :group
  end
end
