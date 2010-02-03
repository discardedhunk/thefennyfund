class AddBandToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :band_name, :string
  end

  def self.down
    remove_column :products, :band_name
  end
end
