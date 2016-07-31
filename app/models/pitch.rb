class Pitch < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
  validates :max_persons, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :length, presence: true, numericality: { greater_than: 0 }
  validates :width,  presence: true, numericality: { greater_than: 0 }

  belongs_to :site
  belongs_to :type, class_name: 'PitchType', foreign_key: :pitch_type_id
  has_many :rates
  has_many :bookings

  accepts_nested_attributes_for :rates, reject_if: :all_blank, allow_destroy: true

  def booked?(from, to)
    Pitch.joins(:bookings).where(
      'pitches.id = :id AND ' +
      '(bookings.start_date < :from AND bookings.end_date > :from) OR ' +
      '(bookings.start_date < :to   AND bookings.end_date > :to) OR ' +
      '(bookings.start_date = :from AND bookings.end_date = :to)',
        {id: id, from: from, to: to}
    ).present?
  end
end
