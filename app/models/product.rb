class Product < ActiveRecord::Base

  has_many :orders, :through => :line_items
  has_many :line_items

  has_attached_file :photo,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => ":attachment/:id/:filename",
                    :bucket => 'thefennyfund_images'

  has_attached_file :music,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => ":attachment/:id/:filename",
                    :bucket => 'thefennyfund_music_files',
                    :s3_permissions => 'private'

  def self.find_products_for_sale
    find(:all, :order => "title")
  end
  
  validates_presence_of :title, :description #, :image_url
  validates_numericality_of :price

  validates_uniqueness_of :title
  validates_length_of :title,
                      :in => 5..30,
                      :message => 'must be between 5 and 30 characters'
  validate :price_must_be_at_least_a_cent
  #validates_format_of :image_url,
  #                    :with => %r{\.(gif|jpg|png)$}i,
  #                    :message => 'must be a URL for GIF, JPG ' + 'or PNG image.'

  protected
    def price_must_be_at_least_a_cent
      errors.add(:price, 'should be at least 0.01') if price.nil? || price < 0.01
    end
    
end
