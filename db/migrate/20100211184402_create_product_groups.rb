class CreateProductGroups < ActiveRecord::Migration
  def self.up
    create_table :product_groups do |t|
      t.integer :product_id, :null => false, :options =>
        "CONSTRAINT fk_product_group_products REFERENCES products(id)"
      t.string :name, :null => false
      t.decimal :discount, :null => false, :precision => 2, :scale => 2
      
      t.timestamps
    end
  end

  def self.down
    drop_table :product_groups
  end
end
