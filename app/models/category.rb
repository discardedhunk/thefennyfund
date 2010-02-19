class Category < ActiveRecord::Base

  has_many :products

  validates_uniqueness_of :name

  validates_length_of :name,
                      :in => 1..100,
                      :message => 'must be between 1 and 100 characters'
  
end
