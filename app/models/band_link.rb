class BandLink < ActiveRecord::Base
  belongs_to :product

  def get_link
    "<a href=\"#{url}\">#{name}</a>"
  end
end
