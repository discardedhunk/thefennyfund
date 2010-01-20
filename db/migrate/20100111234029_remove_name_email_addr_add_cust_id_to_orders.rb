class RemoveNameEmailAddrAddCustIdToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :name
    remove_column :orders, :address
    remove_column :orders, :email

    add_column :orders, :customer_id, :integer, :null => false, :options =>
      "CONSTRAINT fk_customer_id_orders REFERENCES customers(id)"
  end

  def self.down
    add_column :orders, :name, :string
    add_column :orders, :address, :string
    add_column :orders, :email, :string

    remove_column :orders, :customer_id
  end
end
