class PitchPriceCalculator

  def initialize(pitch, from_date, to_date, guests=1, relevant_rates_given=false)
    @pitch     = pitch
    @from_date = Date.parse(from_date)
    @to_date   = Date.parse(to_date)
    @guests    = guests
    @relevant_rates_given = relevant_rates_given
  end

  def calculate
    return nil unless covered_by_rates?
    normalized_rates.reduce(0) do |acc, r|
      acc + r.amount * r.period_in_nights * @guests
    end
  end

  def covered_by_rates?
    @covered ||= period_in_nights == nights_covered_by_rates_in_period
  end

  private

  def relevant_rates
    if @relevant_rates_given
      @pitch.rates
    else
      @pitch.rates.relevant_for_period(@from_date, @to_date)
      # @pitch.rates.reject { |r| r.from_date > @to_date || r.to_date < @from_date }
    end
  end

  def normalized_rates
    @normalized_rates ||= relevant_rates.map do |rate|
      rate.from_date = @from_date if rate.from_date < @from_date
      if rate.to_date >= @to_date
        rate.to_date = @to_date
        rate.period_in_nights = date_diff_in_nights(rate.from_date, rate.to_date)
      else
        rate.period_in_nights = date_diff_in_nights(rate.from_date, rate.to_date) + 1
      end
      rate
    end
  end

  def nights_covered_by_rates_in_period
    normalized_rates.reduce(0) { |acc, r| acc + r.period_in_nights }
  end

  def period_in_nights
    date_diff_in_nights(@from_date, @to_date)
  end

  def date_diff_in_nights(date1, date2)
    (date2 - date1).to_i
  end
end
