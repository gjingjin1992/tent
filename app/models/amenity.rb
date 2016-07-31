class Amenity < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :site_amenities
  has_many :sites, through: :site_amenities
end
