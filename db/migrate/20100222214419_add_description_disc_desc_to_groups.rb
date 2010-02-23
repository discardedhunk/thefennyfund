class AddDescriptionDiscDescToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :description, :text
    add_column :groups, :discout_desc, :string
  end

  def self.down
    remove_column :groups, :description, :text
    remove_column :groups, :discout_desc, :string
  end
end
