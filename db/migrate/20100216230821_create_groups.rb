class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name, :null => false, :unique => true
      t.decimal :discount, :null => false, :precision => 2, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
