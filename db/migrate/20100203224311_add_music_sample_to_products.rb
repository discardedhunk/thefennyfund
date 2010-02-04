class AddMusicSampleToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :music_sample_file_name, :string
    add_column :products, :music_sample_content_type, :string
    add_column :products, :music_sample_file_size, :integer
  end

  def self.down
    remove_column :products, :music_sample_file_name
    remove_column :products, :music_sample_content_type
    remove_column :products, :music_sample_file_size
  end
end
