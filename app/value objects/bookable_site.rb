class BookableSite
  include Rails.application.routes.url_helpers
  include ActiveSupport::NumberHelper

  attr_reader :price, :name

  def initialize(site, price, guests, checkin, checkout)
    @id = site.id
    @url = site_path(site)
    @name  = site.name
    @image = site.main_image(:medium)
    @description = site.general_desc
    @price     = price
    @guests    = guests
    @checkin   = parse_date(checkin)
    @checkout  = parse_date(checkout)
    @town      = site.town
    @address   = site.address1
    @longitude = site.coordinates.longitude
    @latitude  = site.coordinates.latitude
    @formatted_price = number_to_currency(price, unit: "£", precision: 0)
  end

  def parse_date(d)
    Date.parse(d).strftime("%b %d.")
  end
end
