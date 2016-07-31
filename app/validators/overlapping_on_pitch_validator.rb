class OverlappingOnPitchValidator < ActiveModel::Validator

  # Checks if record with start - end date overlaps
  # with other records that belong to the same pitch

  def initialize(options)
    super
    @start_date = options[:start_field_name]
    @end_date   = options[:end_field_name]
    @error_msg  = options[:message]

    # For example, one booking can end at 2016-01-15 and another can start at the same day
    # But for rates that doesn't make sense. If one ends at 2016-01-15, next one can
    # start at 2016-01-16

    @can_share_day = options[:can_share_day].nil? ? true : options[:can_share_day]
  end

  def validate(record)
    if contains_existing?(record)
      record.errors.add(@start_date, @error_msg)
      record.errors.add(@end_date,   @error_msg)
    else
      if overlaps_with_existing?(record, record[@start_date])
        record.errors.add(@start_date, @error_msg)
      end
      if overlaps_with_existing?(record, record[@end_date])
        record.errors.add(@end_date, @error_msg)
      end
    end
  end

  def overlaps_with_existing?(record, date)
    if @can_share_day
      query = "pitch_id = ? AND ? > #{@start_date} AND ? < #{@end_date} AND id <> ?"
    else
      query = "pitch_id = ? AND ? >= #{@start_date} AND ? <= #{@end_date} AND id <> ?"
    end
    record.class.where(query, record.pitch_id, date, date, record.id.to_i).any?
  end

  def contains_existing?(record)
    record.class.where(
      "pitch_id = ? AND ? < #{@start_date} AND ? > #{@end_date} AND id <> ?",
        record.pitch_id, record[@start_date], record[@end_date], record.id.to_i
    ).any?
  end
end
