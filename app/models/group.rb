class Group < ActiveRecord::Base

  has_many :products

  validates_numericality_of :discount
  validates_uniqueness_of :name
  validates_length_of :name,
                      :in => 1..100,
                      :message => 'must be between 1 and 100 characters'

  protected
    def discount_must_be_one_percent
      errors.add(:discount, 'should be at least 0.01') if discount.nil? || discount < 0.01
    end
  
end
