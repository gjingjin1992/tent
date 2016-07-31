require 'rails_helper'

RSpec.describe 'Search' do

  before do
    # Sites
    @gloucester = FactoryGirl.create(
      :site, name: 'Gloucester', longitude: -2.235239, latitude: 51.865263)

    @manchester = FactoryGirl.create(
      :site, name: 'Manchester', longitude: -2.25231, latitude: 53.476667)

    @oxford = FactoryGirl.create(
      :site, name: 'Oxford', longitude: -1.24141, latitude: 51.76136)

    @birmingham = FactoryGirl.create(
      :site, name: 'Birmingham', longitude: -1.895177, latitude: 52.482424)

    # Amenities
    @amenity1 = FactoryGirl.create(:amenity, name: 'amenity1')
    @amenity2 = FactoryGirl.create(:amenity, name: 'amenity2')

    FactoryGirl.create(:site_amenity, site: @gloucester, amenity: @amenity1)
    FactoryGirl.create(:site_amenity, site: @gloucester, amenity: @amenity2)
    FactoryGirl.create(:site_amenity, site: @manchester, amenity: @amenity1)
    FactoryGirl.create(:site_amenity, site: @manchester, amenity: @amenity2)
    FactoryGirl.create(:site_amenity, site: @oxford,     amenity: @amenity1)
    FactoryGirl.create(:site_amenity, site: @birmingham, amenity: @amenity2)

    # Pitch types
    @type1 = FactoryGirl.create(:pitch_type, name: 'type1')
    @type2 = FactoryGirl.create(:pitch_type, name: 'type2')

    # Pitches
    @pitch1 = FactoryGirl.create(
      :pitch, site: @gloucester, type: @type1, max_persons: 10)
    @pitch2 = FactoryGirl.create(
      :pitch, site: @gloucester, type: @type1, max_persons: 5)

    @pitch3 = FactoryGirl.create(
      :pitch, site: @manchester, type: @type1, max_persons: 4)
    @pitch4 = FactoryGirl.create(
      :pitch, site: @manchester, type: @type2, max_persons: 8)

    @pitch5 = FactoryGirl.create(
      :pitch, site: @oxford, type: @type2, max_persons: 6)
    @pitch6 = FactoryGirl.create(
      :pitch, site: @oxford, type: @type1, max_persons: 2)

    @pitch7 = FactoryGirl.create(
      :pitch, site: @birmingham, type: @type1, max_persons: 5)
    @pitch8 = FactoryGirl.create(
      :pitch, site: @birmingham, type: @type2, max_persons: 10)

    # Rates
    FactoryGirl.create(
      :rate, pitch: @pitch1, from_date: '2016-01-01', to_date: '2016-06-30', amount: 10)
    FactoryGirl.create(
      :rate, pitch: @pitch1, from_date: '2016-07-01', to_date: '2016-12-31', amount: 20)

    FactoryGirl.create(
      :rate, pitch: @pitch2, from_date: '2016-01-01', to_date: '2016-06-15', amount: 8)
    FactoryGirl.create(
      :rate, pitch: @pitch2, from_date: '2016-06-16', to_date: '2016-12-31', amount: 15)

    FactoryGirl.create(
      :rate, pitch: @pitch3, from_date: '2016-01-01', to_date: '2016-03-31', amount: 5)
    FactoryGirl.create(
      :rate, pitch: @pitch3, from_date: '2016-04-01', to_date: '2016-12-31', amount: 5)

    FactoryGirl.create(
      :rate, pitch: @pitch4, from_date: '2016-01-01', to_date: '2016-12-31', amount: 25)

    FactoryGirl.create(
      :rate, pitch: @pitch5, from_date: '2016-02-15', to_date: '2016-03-15', amount: 5)

    # Bookings
    @booking1 = FactoryGirl.create(
      :booking, pitch: @pitch1, start_date: '2016-01-01', end_date: '2016-02-01')
    @booking2 = FactoryGirl.create(
      :booking, pitch: @pitch2, start_date: '2016-03-01', end_date: '2016-04-01')

    @booking3 = FactoryGirl.create(
      :booking, pitch: @pitch3, start_date: '2016-02-01', end_date: '2016-03-01')
    @booking4 = FactoryGirl.create(
      :booking, pitch: @pitch4, start_date: '2016-04-01', end_date: '2016-05-01')

    @booking5 = FactoryGirl.create(
      :booking, pitch: @pitch5, start_date: '2016-03-01', end_date: '2016-04-01')
    @booking6 = FactoryGirl.create(
      :booking, pitch: @pitch6, start_date: '2016-05-01', end_date: '2016-06-01')

    @booking7 = FactoryGirl.create(
      :booking, pitch: @pitch7, start_date: '2016-04-01', end_date: '2016-05-01')
    @booking8 = FactoryGirl.create(
      :booking, pitch: @pitch8, start_date: '2016-06-01', end_date: '2016-07-01')
  end

  describe '#find' do

    before do
      # Between london and liverpool
      # contains all cities from before block except manchester
      @bounds = {
        sw: { lng: -0.126182, lat: 51.500083},
        ne: { lng: -2.9901,   lat: 53.4115}
      }
    end

    it 'finds correct sites for bounds/guests combo' do
      search = Search.new(bounds: @bounds, guests: 2)
      expect(search.send(:find)).to match_array([@gloucester, @oxford, @birmingham])

      search = Search.new(bounds: @bounds, guests: 8)
      expect(search.send(:find)).to match_array([@gloucester, @birmingham])
    end

    it 'finds correct sites for bounds/guests/pitch_type combo' do
      search = Search.new(bounds: @bounds, guests: 2, pitch_type: 'type2')
      expect(search.send(:find)).to match_array([@oxford, @birmingham])

      search = Search.new(bounds: @bounds, guests: 8, pitch_type: 'type2')
      expect(search.send(:find)).to match_array([@birmingham])
    end

    it 'finds correct sites for bounds/guests/pitch_type/booking date combo' do
      search = Search.new(
        bounds: @bounds, guests: 2, pitch_type: 'type2',
        start: '2016-02-01', end: '2016-03-01'
      )
      expect(search.send(:find)).to match_array([@oxford])

      search = Search.new(
        bounds: @bounds, guests: 2, pitch_type: 'type2',
        start: '2016-03-01', end: '2016-04-01'
      )
      expect(search.send(:find)).to match_array([])

      search = Search.new(
        bounds: @bounds, guests: 15, pitch_type: 'type1',
        start: '2016-03-15', end: '2016-04-15'
      )
      expect(search.send(:find)).to match_array([])

      search = Search.new(
        bounds: @bounds, guests: 10, pitch_type: 'type1',
        start: '2016-03-15', end: '2016-04-15'
      )
      expect(search.send(:find)).to match_array([@gloucester])

      search = Search.new(
        bounds: @bounds, guests: 2,
        start: '2016-02-15', end: '2016-02-20'
      )
      expect(search.send(:find)).to match_array([@gloucester, @oxford])
    end

    it 'finds correct sites for bounds/guests/pitch_type/booking date/amenities combo' do
      search = Search.new(
        bounds: @bounds, guests: 2, pitch_type: 'type2',
        start: '2016-02-01', end: '2016-03-01', amenities: ['amenity1']
      )
      expect(search.send(:find)).to match_array([@oxford])

      search = Search.new(
        bounds: @bounds, guests: 2, pitch_type: 'type2',
        start: '2016-03-01', end: '2016-04-01', amenities: ['amenity1']
      )
      expect(search.send(:find)).to match_array([])

      search = Search.new(
        bounds: @bounds, guests: 5, pitch_type: 'type1',
        start: '2016-03-15', end: '2016-02-25', amenities: ['amenity1', 'amenity2']
      )
      expect(search.send(:find)).to match_array([@gloucester])

      search = Search.new(
        start: '2016-08-01', end: '2016-09-01', amenities: ['amenity2'], guests: 10
      )
      expect(search.send(:find)).to match_array([@gloucester])
    end

    it 'includes only pitches of given type' do
      search = Search.new(bounds: @bounds, pitch_type: 'type1')
      result = search.send(:find)

      expect(result.first.name).to eq('Gloucester')
      expect(result.first.pitches.length).to eq(2)

      expect(result.second.name).to eq('Oxford')
      expect(result.second.pitches.length).to eq(1)
    end

    it 'includes only pitches that can take given number of guests' do
      search = Search.new(guests: 5)
      result = search.send(:find)

      expect(result.first.name).to eq('Gloucester')
      expect(result.first.pitches.length).to eq(2)

      expect(result.second.name).to eq('Manchester')
      expect(result.second.pitches.length).to eq(1)

      expect(result.third.name).to eq('Oxford')
      expect(result.third.pitches.length).to eq(1)

      expect(result.fourth.name).to eq('Birmingham')
      expect(result.fourth.pitches.length).to eq(2)
    end

    it 'includes only pitches that are not booked and covered by rates' do
      search = Search.new(start: '2016-02-01', end: '2016-03-01')
      result = search.send(:find)

      expect(result).to match_array([@gloucester, @manchester, @oxford])

      expect(result.first.name).to eq('Gloucester')
      expect(result.first.pitches.length).to eq(2)

      expect(result.second.name).to eq('Manchester')
      expect(result.second.pitches.length).to eq(1)

      expect(result.third.name).to eq('Oxford')
      expect(result.third.pitches.length).to eq(1)
    end

    it 'can combine multiple params to load correct pitches' do
      search = Search.new(
        pitch_type: 'type1', guests: 5, start: '2016-03-15', end: '2016-04-15')
      result = search.send(:find)

      expect(result).to match_array([@gloucester])
      expect(result.first.name).to eq('Gloucester')
      expect(result.first.pitches.length).to eq(1)


      search = Search.new(
        pitch_type: 'type2', guests: 8, start: '2016-05-15', end: '2016-06-01')
      result = search.send(:find)

      expect(result).to match_array([@manchester])

      expect(result.first.name).to eq('Manchester')
      expect(result.first.pitches.length).to eq(1)
      expect(result.first.pitches.first).to eq(@pitch4)
    end
  end

  describe '#find_with_min_price' do

    it 'returns correct price when there is only one matching pitch' do
      search = Search.new(
        bounds: @bounds, guests: 5, pitch_type: 'type1',
        start: '2016-03-01', end: '2016-03-15', amenities: ['amenity1', 'amenity2']
      )
      result = search.find_with_min_price
      expect(result.length).to eq(1)
      expect(result.first.name).to eq('Gloucester')
      expect(result.first.price).to eq(700)
    end

    it 'returns min price when there are multiple pitches' do
      search = Search.new(
        bounds: @bounds, guests: 5, pitch_type: 'type1',
        start: '2016-06-10', end: '2016-07-10', amenities: ['amenity1']
      )
      result = search.find_with_min_price
      expect(result.length).to eq(1)
      expect(result.first.name).to eq('Gloucester')
      expect(result.first.price).to eq(1950)
    end

    it 'returns empty array when no appropriate rates exist' do
      search = Search.new(
        bounds: @bounds, guests: 10, pitch_type: 'type2',
        start: '2016-11-01', end: '2016-11-15', amenities: ['amenity2']
      )
      expect(search.find_with_min_price).to match_array([])
    end
  end
end
