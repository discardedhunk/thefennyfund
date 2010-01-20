class MakeLoginUniqueInCustomers < ActiveRecord::Migration
  def self.up
    change_column :customers, :login, :string, :unique => true
  end

  def self.down
    change_column :customers, :login, :string, :unique => false
  end
end
