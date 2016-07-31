class Search

  def initialize(options)
    @bounds = options[:bounds]
    @guests = options[:guests].to_i
    @start  = options[:start]
    @end    = options[:end]
    @amenities  = options[:amenities]
    @pitch_type = options[:pitch_type]
  end

  def find_with_min_price
    bookable_sites = find.map do |site|
      prices = site.pitches.map do |pitch|
        PitchPriceCalculator.new(pitch, @start, @end, @guests, true).calculate
      end
      min_price = prices.reject { |price| price.nil? }.min
      BookableSite.new(site, min_price, @guests, @start, @end)
    end
    bookable_sites.reject { |bs| bs.price.nil? }.sort { |x, y| x.price <=> y.price }
  end

  private

  def find
    Site
      .in_bounds(@bounds)
      .with_amenities(@amenities)
      .of_pitch_type(@pitch_type)
      .for_guests(@guests)
      .not_booked_during(@start, @end)
      .with_relevant_rates(@start, @end)
  end
end
