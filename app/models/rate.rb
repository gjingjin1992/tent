class Rate < ActiveRecord::Base
  validates_date :from_date, allow_blank: false, before: :to_date
  validates_date :to_date,   allow_blank: false, after:  :from_date
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_with OverlappingOnPitchValidator,
    message: 'overlaps with existing rate',
    start_field_name: :from_date,
    end_field_name:   :to_date,
    can_share_day:    false

  belongs_to :pitch

  attr_accessor :period_in_nights


  # Scopes

  scope :for_pitch, ->(pitch) { where('pitch_id = ?', pitch.id) }

  scope :relevant_for_period,
    -> (from, to) { where('NOT (from_date > ? OR to_date < ?)', to, from) }
end
