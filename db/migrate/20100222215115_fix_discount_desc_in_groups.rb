class FixDiscountDescInGroups < ActiveRecord::Migration
  def self.up
    rename_column :groups, :discout_desc, :discount_desc
  end

  def self.down
    rename_column :groups, :discount_desc, :discout_desc
  end
end
