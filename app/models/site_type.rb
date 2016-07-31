class SiteType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :sites
end
