class SiteAmenity < ActiveRecord::Base
  belongs_to :site
  belongs_to :amenity
end
