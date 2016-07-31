class Site < ActiveRecord::Base

  attr_accessor :longitude, :latitude

  validates :name, presence: true, length: { minimum: 5, maximum: 100 }, uniqueness: {scope: :owner}
  validates :email, presence: true, email_format: { message: 'is invalid' }
  validates :address1, presence: true, length: { maximum: 300 }
  validates :address2, length: { maximum: 300 }
  validates :address3, length: { maximum: 300 }
  validates :country, presence: true, length: { minimum: 2 }
  validates :county, presence: true
  validates :city, presence: true
  validates :town, presence: true
  validates :postcode, presence: true
  validates :telephone, presence: true
  validates :general_desc, presence: true, length: { maximum: 2_000 }
  validates :detailed_desc, presence: true, length: { maximum: 5_000 }
  validates_time :arrival_time,   allow_blank: false
  validates_time :departure_time, allow_blank: false
  validates :latitude, numericality: {
    greater_than_or_equal_to: -90, less_than_or_equal_to: 90
  }, if: 'latitude.present?'
  validates :longitude, numericality: {
    greater_than_or_equal_to: -180, less_than_or_equal_to: 180
  }, if: 'longitude.present?'
  validates :coordinates, presence: true

  has_attached_file :main_image,
    styles: {
      large: '1000x1000>',
      medium: '250x400>'
    },
    default_url: "/images/:style/missing.png"
  validates_attachment_content_type :main_image, content_type: /\Aimage\/.*\Z/

  belongs_to :owner
  belongs_to :type, class_name: 'SiteType', foreign_key: :site_type_id
  has_many :pitches
  has_many :site_amenities, dependent: :destroy
  has_many :amenities, through: :site_amenities
  has_many :images, class_name: 'SiteImage', dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :site_amenities, allow_destroy: true

  before_validation :insert_point, if: 'latitude && longitude'

  def self.in_bounds(bounds=nil)
    return all if bounds.blank?

    lat_min = bounds[:sw][:lat]
    lng_min = bounds[:sw][:lng]
    lat_max = bounds[:ne][:lat]
    lng_max = bounds[:ne][:lng]

    # Two ways to query.

    # Geometry is probably what we should use here! It uses cartesian plane for
    # calculations but is precise enough for city, state or region...

    # Using geometry - simple math => less precise & faster

    Site.where(
      'ST_Contains(ST_MakeEnvelope(?, ?, ?, ?, 4326), coordinates::geometry)', lng_min, lat_min, lng_max, lat_max
    )

    # Using geography - complicated math => more pricise & far more expensive

    # Site.where(
    #   "ST_Covers(ST_MakeEnvelope(?, ?, ?, ?, 4326)::geography, coordinates)",
    #     lng_min, lat_min, lng_max, lat_max
    # )

    # NOTE: ST_Contains doesn't include points on border, while ST_Covers does
  end

  def self.of_pitch_type(pitch_type=nil)
    return all if pitch_type.blank?
    includes(pitches: :type).where('pitch_types.name' => pitch_type).uniq
  end

  def self.for_guests(guests=nil)
    return all if guests.blank?
    includes(:pitches).where('pitches.max_persons >= ?', guests)
      .references(:pitches)
      .uniq
  end

  def self.not_booked_during(from=nil, to=nil)
    return all if from.blank? || to.blank?
    pitches = Pitch
                .select(:id)
                .joins(:bookings)
                .where('bookings.start_date >= ? OR bookings.end_date <= ?', to, from)
    includes(:pitches)
      .where("pitches.id IN (#{pitches.to_sql})")
      .references(:pitches)
      .uniq
  end

  def self.with_amenities(amenities=nil)
    return all if amenities.blank?
    sites = joins(:amenities)
      .where('amenities.name IN (?)', amenities)
      .group('id')
      .having('COUNT(DISTINCT amenities.name) = ?', amenities.size)
      .uniq
    where(id: sites)
  end

  def self.with_relevant_rates(from=nil, to=nil)
    return includes(pitches: :rates) if from.blank? || to.blank?
    includes(pitches: :rates)
      .where('NOT (rates.from_date > ? OR rates.to_date < ?)', to, from)
      .references(:rates)
  end

  private

  def insert_point
    self.coordinates = 'POINT(%f %f)' % [longitude, latitude]
  rescue
  end
end
