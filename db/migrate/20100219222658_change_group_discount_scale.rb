class ChangeGroupDiscountScale < ActiveRecord::Migration
  def self.up
    change_column :groups, :discount, :decimal, :precision => 3, :scale => 3
  end

  def self.down
    change_column :groups, :discount, :decimal, :precision => 2, :scale => 2
  end
end
