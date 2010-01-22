# == Schema Information
# Schema version: 20100119154802
#
# Table name: customers
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  login           :string(255)
#  address         :string(255)
#  hashed_password :string(255)
#  salt            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'digest/sha1'

class Customer < ActiveRecord::Base

  before_validation :set_login
  
  has_many :orders

  validates_presence_of :first_name, :last_name, :address, :email

  validates_uniqueness_of :login

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  validate :password_non_blank

  validates_length_of :password,
                      :in => 8..20,
                      :message => 'must be between 8 and 20 characters'

  def self.authenticate(login, password)
    customer = self.find_by_login(login)
    if customer
      expected_password = encrypted_password(password, customer.salt)
        if customer.hashed_password != expected_password
          customer = nil
        end
    end
    puts "FOOOOOO"
    customer
  end

  #'password' is a virtual attribute
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Customer.encrypted_password(self.password, self.salt)
  end

  
  private
  
    def set_login
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.login = email
    end

    def password_non_blank
      errors.add(:password, "Missing password") if hashed_password.blank?
    end

    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s
    end

    def self.encrypted_password(password, salt)
      string_to_hash = password + "wibble" + salt
      Digest::SHA1.hexdigest(string_to_hash)
    end
end
