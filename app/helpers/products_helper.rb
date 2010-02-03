module ProductsHelper

  def add_link_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :band_links, :partial => 'band_link', :object => BandLink.new
    end
  end

end
