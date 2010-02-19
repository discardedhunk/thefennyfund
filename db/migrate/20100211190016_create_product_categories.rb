class CreateProductCategories < ActiveRecord::Migration
  def self.up
    create_table :product_categories do |t|
      t.integer :product_id, :null => false, :options =>
        "CONSTRAINT fk_product_category_products REFERENCES products(id)"
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :product_categories
  end
end
