class CreateBandLinks < ActiveRecord::Migration
  def self.up
    create_table :band_links do |t|
      t.integer :product_id, :null => false, :options =>
        "CONSTRAINT fk_band_link_products REFERENCES products(id)"
      t.string :name,	:null => false
      t.string :url,	:null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :band_links
  end
end
