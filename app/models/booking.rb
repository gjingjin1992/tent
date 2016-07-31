class Booking < ActiveRecord::Base
  validates_date :start_date, allow_blank: false, before: :end_date
  validates_date :end_date,   allow_blank: false, after:  :start_date
  validates_with OverlappingOnPitchValidator,
    message: 'pitch is occupied',
    start_field_name: :start_date,
    end_field_name:   :end_date

  belongs_to :booker
  belongs_to :pitch
end
