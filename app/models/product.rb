# == Schema Information
# Schema version: 20100119154802
#
# Table name: products
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  description        :text
#  image_url          :string(255)
#  dl_url             :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  price              :decimal(8, 2)   default(0.0)
#  category           :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  music_file_name    :string(255)
#  music_content_type :string(255)
#  music_file_size    :integer
#

class Product < ActiveRecord::Base

  has_many :orders, :through => :line_items
  has_many :line_items
  has_many :band_links

  has_attached_file :photo,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => ":attachment/:id/:filename",
                    :bucket => 'thefennyfund_image_files2'

  has_attached_file :music,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => ":attachment/:id/:filename",
                    :bucket => 'thefennyfund_music_files2',
                    :s3_permissions => 'private'

  
  validates_presence_of :title, :description #, :image_url
  validates_numericality_of :price

  validates_uniqueness_of :title
  validates_length_of :title,
                      :in => 1..200,
                      :message => 'must be between 1 and 200 characters'
  validate :price_must_be_at_least_a_cent
  #validates_format_of :image_url,
  #                    :with => %r{\.(gif|jpg|png)$}i,
  #                    :message => 'must be a URL for GIF, JPG ' + 'or PNG image.'

  validates_associated :band_links

  after_update :save_band_links

  def existing_band_link_attributes=(band_link_attributes)
    band_links.reject(&:new_record?).each do |band_link|
      attributes = band_link_attributes[band_link.id.to_s]
      if attributes 
        band_link.attributes = attributes
      else
        band_links.delete(band_link)
      end
    end
  end

  def self.find_products_for_sale
    find(:all, :order => "grouping, band_name, title")
  end

  def new_band_link_attributes=(band_link_attributes)
    band_link_attributes.each do |attributes|
      band_links.build(attributes)
    end
  end

  def save_band_links
    band_links.each do |band_link|
      band_link.save(false)
    end
  end
  
  protected
    def price_must_be_at_least_a_cent
      errors.add(:price, 'should be at least 0.01') if price.nil? || price < 0.01
    end
    
end
