class RenameGroupInProducts < ActiveRecord::Migration
  def self.up
    rename_column :products, :group, :grouping
  end

  def self.down
    rename_column :products, :grouping, :group
  end
end
