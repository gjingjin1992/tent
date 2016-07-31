require 'rails_helper'

RSpec.describe Site, type: :model do

  describe 'validations' do
    it 'passes with proper data' do
      expect(FactoryGirl.build(:site)).to be_valid
    end

    it_behaves_like 'nameable'
    it_behaves_like 'emailable'
    it_behaves_like 'addressable'

    describe 'name' do

      it 'is unique per owner' do
        owner1 = FactoryGirl.create(:owner)
        owner2 = FactoryGirl.create(:owner)

        site1 = FactoryGirl.create(:site, owner: owner1, name: 'my site')

        site2 = FactoryGirl.build(:site, owner: owner2, name: 'my site')
        expect(site2).to be_valid

        site3 = FactoryGirl.build(:site, owner: owner1, name: 'my site')
        expect(site3).not_to be_valid
        expect(site3.errors[:name]).to include('has already been taken')
      end
    end

    describe 'general_desc' do
      it 'cannot be blank' do
        [ '', nil ].each do |general_desc|
          site = FactoryGirl.build(:site, general_desc: general_desc)
          expect(site).not_to be_valid
          expect(site.errors[:general_desc]).to include("can't be blank")
        end
      end

      it 'cannot be longer than 2k chars' do
        expect(FactoryGirl.build(:site, general_desc: 'a' * 2_000)).to be_valid

        site = FactoryGirl.build(:site, general_desc: 'a' * 2_001)
        expect(site).not_to be_valid
        expect(site.errors[:general_desc]).to include('is too long (maximum is 2000 characters)')
      end
    end

    describe 'detailed_desc' do
      it 'cannot be blank' do
        [ '', nil ].each do |detailed_desc|
          site = FactoryGirl.build(:site, detailed_desc: detailed_desc)
          expect(site).not_to be_valid
          expect(site.errors[:detailed_desc]).to include("can't be blank")
        end
      end

      it 'cannot be longer than 5k chars' do
        expect(FactoryGirl.build(:site, detailed_desc: 'a' * 5_000)).to be_valid

        site = FactoryGirl.build(:site, detailed_desc: 'a' * 5_001)
        expect(site).not_to be_valid
        expect(site.errors[:detailed_desc]).to include('is too long (maximum is 5000 characters)')
      end
    end

    describe 'arrival_time' do
      it 'cannot be invalid' do
        ['12:00:00', '1 pm', '14:00', '5'].each do |time|
          expect(FactoryGirl.build(:site, arrival_time: time)).to be_valid
        end

        [nil, '', 'now', 'yesterday', '-2'].each do |time|
          site = FactoryGirl.build(:site, arrival_time: time)
          expect(site).not_to be_valid
          expect(site.errors[:arrival_time]).to include('is not a valid time')
        end
      end
    end

    describe 'departure_time' do
      it 'cannot be invalid' do
        ['12:00:00', '1 pm', '14:00', '5'].each do |time|
          expect(FactoryGirl.build(:site, departure_time: time)).to be_valid
        end

        [nil, '', 'now', 'yesterday', '-2'].each do |time|
          site = FactoryGirl.build(:site, departure_time: time)
          expect(site).not_to be_valid
          expect(site.errors[:departure_time]).to include('is not a valid time')
        end
      end
    end

    describe 'longitude' do
      it 'fails when not a number' do
        site = FactoryGirl.build(:site, longitude: 'far right on the map')
        expect(site).not_to be_valid
        expect(site.errors[:longitude]).to include('is not a number')
      end

      it 'fails when is less than -180 or greater than 180' do
        [-180, 180].each do |l|
          expect(FactoryGirl.build(:site, longitude: l)).to be_valid
        end

        [-181, -191.235216732312].each do |l|
          site = FactoryGirl.build(:site, longitude: l)
          expect(site).not_to be_valid
          expect(site.errors[:longitude]).to include('must be greater than or equal to -180')
        end

        [181, 188.1242923443478].each do |l|
          site = FactoryGirl.build(:site, longitude: l)
          expect(site).not_to be_valid
          expect(site.errors[:longitude]).to include('must be less than or equal to 180')
        end
      end
    end

    describe 'latitude' do
      it 'fails when not a number' do
        site = FactoryGirl.build(:site, latitude: 'up on the map')
        expect(site).not_to be_valid
        expect(site.errors[:latitude]).to include('is not a number')
      end

      it 'fails when is less than -90 or greater than 90' do
        [-90, 90].each do |l|
          expect(FactoryGirl.build(:site, latitude: l)).to be_valid
        end

        [-91, -129.445322167312].each do |l|
          site = FactoryGirl.build(:site, latitude: l)
          expect(site).not_to be_valid
          expect(site.errors[:latitude]).to include('must be greater than or equal to -90')
        end

        [91, 98.12924879472938].each do |l|
          site = FactoryGirl.build(:site, latitude: l)
          expect(site).not_to be_valid
          expect(site.errors[:latitude]).to include('must be less than or equal to 90')
        end
      end
    end

    describe 'coordinates' do
      # This field is supposed to be changed through virtual attrs longitude & latitude
    end
  end

  describe 'associations' do

    it 'belongs to owner' do
      owner = FactoryGirl.create(:owner)
      site  = FactoryGirl.create(:site, owner: owner)
      expect(site.owner).to eq(owner)
    end

    it 'belongs_to type' do
      site_type = FactoryGirl.create(:site_type)
      site = FactoryGirl.create(:site, type: site_type)

      expect(site.type).to eq(site_type)
    end

    it 'has_many pitches' do
      site = FactoryGirl.create(:site)
      pitch1 = FactoryGirl.create(:pitch, site: site)
      pitch2 = FactoryGirl.create(:pitch)
      pitch3 = FactoryGirl.create(:pitch, site: site)

      expect(site.pitches).to match_array([pitch1, pitch3])
    end

    it 'has_many site_amenities' do
      site = FactoryGirl.create(:site)
      site_amenity1 = FactoryGirl.create(:site_amenity, site: site)
      site_amenity2 = FactoryGirl.create(:site_amenity)
      site_amenity3 = FactoryGirl.create(:site_amenity, site: site)
      expect(site.site_amenities).to match_array([site_amenity1, site_amenity3])
    end

    it 'has_many amenities thorough site_amenities' do
      site1 = FactoryGirl.create(:site)
      site2 = FactoryGirl.create(:site)
      amenity1 = FactoryGirl.create(:amenity)
      amenity2 = FactoryGirl.create(:amenity)
      amenity3 = FactoryGirl.create(:amenity)
      amenity4 = FactoryGirl.create(:amenity)

      FactoryGirl.create(:site_amenity, site: site1, amenity: amenity1)
      FactoryGirl.create(:site_amenity, site: site1, amenity: amenity2)
      FactoryGirl.create(:site_amenity, site: site1, amenity: amenity3)
      FactoryGirl.create(:site_amenity, site: site2, amenity: amenity4)

      expect(site1.amenities).to match_array([amenity1, amenity2, amenity3])
      expect(site2.amenities).to match_array([amenity4])
    end

    it 'has_many images' do
      site = FactoryGirl.create(:site)
      site_image1 = FactoryGirl.create(:site_image, site: site)
      site_image2 = FactoryGirl.create(:site_image)
      site_image3 = FactoryGirl.create(:site_image, site: site)
      expect(site.images).to match_array([site_image1, site_image3])
    end
  end

  describe 'scopes' do

    describe 'in_bounds' do

      before do
        @liverpool = FactoryGirl.create(
          :site, name: 'Liverpool', longitude: -2.9901, latitude: 53.4115)
        @london = FactoryGirl.create(
          :site, name: 'London', longitude: -0.126182, latitude: 51.500083)

        @oxford = FactoryGirl.create(
          :site, name: 'Oxford', longitude: -1.24141, latitude: 51.76136)
        @birmingham = FactoryGirl.create(
          :site, name: 'Birmingham', longitude: -1.895177, latitude: 52.482424)
        @appelton = FactoryGirl.create(
          :site, name: 'Appelton', longitude: -2.56657, latitude: 53.356199)
        @gloucester = FactoryGirl.create(
          :site, name: 'Gloucester', longitude: -2.235239, latitude: 51.865263)

        @manchester = FactoryGirl.create(
          :site, name: 'Manchester', longitude: -2.25231, latitude: 53.476667)
        @reading = FactoryGirl.create(
          :site, name: 'Reading', longitude: -0.976367, latitude: 51.454364)
        @cambridge = FactoryGirl.create(
          :site, name: 'Cambridge', longitude: 0.12601, latitude: 52.207439)
        @cardiff = FactoryGirl.create(
          :site, name: 'Cardiff', longitude: -3.174838, latitude: 51.481479)
      end

      it 'returns only sites inside given borders' do
        bounds = {
          sw: { lng: @london.longitude,    lat: @london.latitude },
          ne: { lng: @liverpool.longitude, lat: @liverpool.latitude }
        }
        result = Site.in_bounds(bounds)
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([
          @oxford, @birmingham, @appelton, @gloucester
        ])
      end

      it 'returns empty relation when there are no matches' do
        bounds = {
          sw: { lng: @birmingham.longitude, lat: @birmingham.latitude },
          ne: { lng: @oxford.longitude,     lat: @oxford.latitude }
        }
        result = Site.in_bounds(bounds)
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([])
      end

      it 'returns all sites if bounds not provided' do
        result = Site.in_bounds
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([
          @liverpool, @london, @oxford, @birmingham, @appelton,
          @gloucester, @manchester, @reading, @cambridge, @cardiff
        ])
      end
    end

    describe 'of_pitch_type' do
      before do
        @type1 = FactoryGirl.create(:pitch_type, name: 'type1')
        @type2 = FactoryGirl.create(:pitch_type, name: 'type2')

        @site1 = FactoryGirl.create(:site, name: 'site1')
        FactoryGirl.create(:pitch, site: @site1, type: @type1)
        FactoryGirl.create(:pitch, site: @site1, type: @type2)

        @site2 = FactoryGirl.create(:site, name: 'site2')
        FactoryGirl.create(:pitch, site: @site2, type: @type2)
        FactoryGirl.create(:pitch, site: @site2, type: @type2)

        @site3 = FactoryGirl.create(:site, name: 'site3')
        FactoryGirl.create(:pitch, site: @site3, type: @type1)
        FactoryGirl.create(:pitch, site: @site3, type: @type1)

        @site4 = FactoryGirl.create(:site)
      end

      it 'returns only sites that have at least one pitch of given type' do
        result = Site.of_pitch_type('type1')
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site3])
      end

      it 'returns empty relation when there is no matches' do
        result = Site.of_pitch_type('type3')
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([])
      end

      it 'returns all sites when given type is nil' do
        result = Site.of_pitch_type
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([
          @site1, @site2, @site3, @site4
        ])
      end
    end

    describe 'for_guests' do
      before do
        @site1 = FactoryGirl.create(:site, name: 'site1')
        FactoryGirl.create(:pitch, site: @site1, max_persons: 6)
        FactoryGirl.create(:pitch, site: @site1, max_persons: 3)

        @site2 = FactoryGirl.create(:site, name: 'site2')
        FactoryGirl.create(:pitch, site: @site2, max_persons: 2)
        FactoryGirl.create(:pitch, site: @site2, max_persons: 4)

        @site3 = FactoryGirl.create(:site, name: 'site3')
        FactoryGirl.create(:pitch, site: @site3, max_persons: 8)
        FactoryGirl.create(:pitch, site: @site3, max_persons: 10)

        @site4 = FactoryGirl.create(:site)
      end

      it 'returns only sites that have pitches that can take given num of guests' do
        result = Site.for_guests(6)
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site3])
      end

      it 'returns all sites where given number of guests is nil' do
        result = Site.for_guests
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([
          @site1, @site2, @site3, @site4
        ])
      end
    end

    describe 'not_booked_during' do
      before do
        @site1 = FactoryGirl.create(:site, name: 'site1')
        @pitch11  = FactoryGirl.create(:pitch, site: @site1)
        FactoryGirl.create(
          :booking, pitch: @pitch11, start_date: '2016-01-01', end_date: '2016-01-15')
        FactoryGirl.create(
          :booking, pitch: @pitch11, start_date: '2016-04-01', end_date: '2016-04-15')
        @pitch12  = FactoryGirl.create(:pitch, site: @site1)
        FactoryGirl.create(
          :booking, pitch: @pitch12, start_date: '2016-01-01', end_date: '2016-01-20')

        @site2 = FactoryGirl.create(:site, name: 'site2')
        @pitch21 = FactoryGirl.create(:pitch, site: @site2)
        FactoryGirl.create(
          :booking, pitch: @pitch21, start_date: '2016-02-01', end_date: '2016-03-01')

        @site3 = FactoryGirl.create(:site, name: 'site3')
        @pitch31 = FactoryGirl.create(:pitch, site: @site3)
        FactoryGirl.create(
          :booking, pitch: @pitch31, start_date: '2016-05-01', end_date: '2016-05-15')
        FactoryGirl.create(
          :booking, pitch: @pitch31, start_date: '2016-06-01', end_date: '2016-06-21')

        @site4 = FactoryGirl.create(:site)
      end

      it 'returns sites that have pitches not booked during given period' do
        result = Site.not_booked_during('2016-01-25', '2016-02-05')
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site3])

        result = Site.not_booked_during('2016-04-10', '2016-04-15')
        expect(result).to match_array([@site1, @site2, @site3])

        result = Site.not_booked_during('2016-01-10', '2016-08-10')
        expect(result).to match_array([])
      end

      it 'takes into account overlapping pitches' do
        result = Site.not_booked_during('2016-01-10', '2016-04-05')
        expect(result).to match_array([@site3])

        result = Site.not_booked_during('2016-05-10', '2016-06-05')
        expect(result).to match_array([@site1, @site2])
      end

      it 'exludes sites with exact match' do
        result = Site.not_booked_during('2016-02-01', '2016-03-01')
        expect(result).to match_array([@site1, @site3])
      end

      it 'includes sites when first booking day match last day in given period' do
        result = Site.not_booked_during('2016-01-25', '2016-02-01')
        expect(result).to match_array([@site1, @site2, @site3])
      end

      it 'includes sites when first day in period matches last booking day' do
        result = Site.not_booked_during('2016-03-01', '2016-03-15')
        expect(result).to match_array([@site1, @site2, @site3])
      end

      it 'last day in bookings can overlap with first date in query' do
        result = Site.not_booked_during('2016-03-01', '2016-03-15')
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site2, @site3])
      end

      it 'first day in bookings can overlap with last date in query' do
        result = Site.not_booked_during('2016-01-25', '2016-02-01')
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site2, @site3])
      end

      it 'returns empty relation when there are no free pitches' do
        result = Site.not_booked_during('2016-01-01', '2016-07-01')
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([])
      end

      it "returns all sites when 'from' or 'to' params not provided" do
        result = Site.not_booked_during
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site2, @site3, @site4])
      end
    end

    describe 'with_amenities' do
      before do
        @site1 = FactoryGirl.create(:site)
        @site2 = FactoryGirl.create(:site)
        @site3 = FactoryGirl.create(:site)

        @amenity1 = FactoryGirl.create(:amenity, name: 'amenity1')
        @amenity2 = FactoryGirl.create(:amenity, name: 'amenity2')

        FactoryGirl.create(:site_amenity, site: @site1, amenity: @amenity1)
        FactoryGirl.create(:site_amenity, site: @site1, amenity: @amenity2)
        FactoryGirl.create(:site_amenity, site: @site2, amenity: @amenity1)
      end

      it 'returns correct sites' do
        result = Site.with_amenities(['amenity1'])
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site2])

        result = Site.with_amenities(['amenity1', 'amenity2'])
        expect(result).to match_array([@site1])
      end

      it 'returns empty relation when there is no match' do
        result = Site.with_amenities(['amenity3'])
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([])
      end

      it 'returns all sites when amenities not provided' do
        result = Site.with_amenities
        expect(result).to be_kind_of(ActiveRecord::Relation)
        expect(result).to match_array([@site1, @site2, @site3])
      end
    end

    describe 'with_relevant_rates' do
      it 'returns only sites with relevant rates' do
        @site1 = FactoryGirl.create(:site)
        @site2 = FactoryGirl.create(:site)
        @site3 = FactoryGirl.create(:site)

        @pitch1 = FactoryGirl.create(:pitch, site: @site1)
        @pitch2 = FactoryGirl.create(:pitch, site: @site2)
        @pitch3 = FactoryGirl.create(:pitch, site: @site3)

        @rate1 = FactoryGirl.create(
          :rate, pitch: @pitch1, from_date: '2016-01-01', to_date: '2016-03-31')
        @rate12 = FactoryGirl.create(
          :rate, pitch: @pitch1, from_date: '2016-04-01', to_date: '2016-08-15')

        @rate2 = FactoryGirl.create(
          :rate, pitch: @pitch2, from_date: '2016-01-01', to_date: '2016-06-15')

        @rate3 = FactoryGirl.create(
          :rate, pitch: @pitch3, from_date: '2016-11-01', to_date: '2016-11-15')

        expect(Site.with_relevant_rates).to match_array([@site1, @site2, @site3])

        result = Site.with_relevant_rates('2016-03-01', '2016-04-15')
        expect(result).to match_array([@site1, @site2])
        expect(result.first.pitches.first.rates).to match_array([@rate1, @rate12])
        expect(result.second.pitches.first.rates).to match_array([@rate2])

        result = Site.with_relevant_rates('2016-04-01', '2016-04-15')
        expect(result).to match_array([@site1, @site2])
        expect(result.first.pitches.first.rates).to match_array([@rate12])
        expect(result.second.pitches.first.rates).to match_array([@rate2])

        result = Site.with_relevant_rates('2016-11-01', '2016-11-15')
        expect(result).to match_array([@site3])
        expect(result.first.pitches.first.rates).to match_array([@rate3])
      end
    end
  end
end
