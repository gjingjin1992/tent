require 'rails_helper'

RSpec.describe Pitch, type: :model do

  describe 'validations' do

    it 'passes with proper data' do
      expect(FactoryGirl.build(:pitch)).to be_valid
    end

    it_behaves_like 'nameable'

    describe 'max_persons' do

      it 'cannot be blank' do
        [ '', nil ].each do |max_persons|
          site = FactoryGirl.build(:pitch, max_persons: max_persons)
          expect(site).not_to be_valid
          expect(site.errors[:max_persons]).to include("can't be blank")
        end
      end

      it 'must be an int greater than 0' do
        [1, 110, 235, 1_000_000].each do |num|
          expect(FactoryGirl.build(:pitch, max_persons: num)).to be_valid
        end

        ['one', 'a lot', true].each do |num|
          pitch = FactoryGirl.build(:pitch, max_persons: num)
          expect(pitch).not_to be_valid
          expect(pitch.errors[:max_persons]).to include('is not a number')
        end

        [3.14, 0.1, 10.0].each do |num|
          pitch = FactoryGirl.build(:pitch, max_persons: num)
          expect(pitch).not_to be_valid
          expect(pitch.errors[:max_persons]).to include('must be an integer')
        end

        [-100, 0].each do |num|
          pitch = FactoryGirl.build(:pitch, max_persons: num)
          expect(pitch).not_to be_valid
          expect(pitch.errors[:max_persons]).to include('must be greater than 0')
        end
      end
    end

    describe 'length' do

      it 'cannot be blank' do
        [ '', nil ].each do |length|
          site = FactoryGirl.build(:pitch, length: length)
          expect(site).not_to be_valid
          expect(site.errors[:length]).to include("can't be blank")
        end
      end

      it 'must be a number greater than 0' do
        [0.1, '2', 3.14, 10, 15.0, '1_000'].each do |num|
          expect(FactoryGirl.build(:pitch, length: num)).to be_valid
        end

        ['one', 'a lot', true].each do |num|
          pitch = FactoryGirl.build(:pitch, length: num)
          expect(pitch).not_to be_valid
          expect(pitch.errors[:length]).to include('is not a number')
        end

        [-100, -10.0, -0.0001].each do |num|
          pitch = FactoryGirl.build(:pitch, length: num)
          expect(pitch).not_to be_valid
          expect(pitch.errors[:length]).to include('must be greater than 0')
        end
      end
    end

    describe 'width' do

      it 'cannot be blank' do
        [ '', nil ].each do |width|
          site = FactoryGirl.build(:pitch, width: width)
          expect(site).not_to be_valid
          expect(site.errors[:width]).to include("can't be blank")
        end
      end

      it 'must be a number greater than 0' do
        [0.1, '2', 3.14, 10, 15.0, '1_000'].each do |num|
          expect(FactoryGirl.build(:pitch, width: num)).to be_valid
        end

        ['one', 'a lot', true].each do |num|
          pitch = FactoryGirl.build(:pitch, width: num)
          expect(pitch).not_to be_valid
          expect(pitch.errors[:width]).to include('is not a number')
        end

        [-100, -10.0, -0.0001].each do |num|
          pitch = FactoryGirl.build(:pitch, width: num)
          expect(pitch).not_to be_valid
          expect(pitch.errors[:width]).to include('must be greater than 0')
        end
      end
    end
  end

  describe 'associations' do

    it 'belongs_to site' do
      site =  FactoryGirl.create(:site)
      pitch = FactoryGirl.create(:pitch, site: site)
      expect(pitch.site).to eq(site)
    end

    it 'belongs_to pitch_type' do
      pitch_type = FactoryGirl.create(:pitch_type)
      pitch = FactoryGirl.create(:pitch, type: pitch_type)
      expect(pitch.type).to eq(pitch_type)
    end

    it 'has_many rates' do
      pitch = FactoryGirl.create(:pitch)
      rate1 = FactoryGirl.create(:rate, pitch: pitch)
      rate2 = FactoryGirl.create(:rate)
      rate3 = FactoryGirl.create(:rate, pitch: pitch)
      expect(pitch.rates).to match_array([rate1, rate3])
    end

    it 'has_many bookings' do
      pitch = FactoryGirl.create(:pitch)
      booking1 = FactoryGirl.create(:booking, pitch: pitch)
      booking2 = FactoryGirl.create(:booking)
      booking3 = FactoryGirl.create(:booking, pitch: pitch)
      expect(pitch.bookings).to match_array([booking1, booking3])
    end
  end

  describe 'methods' do

    describe "#booked?" do

      before do
        @pitch1 = FactoryGirl.create(:pitch)
        FactoryGirl.create(
          :booking, pitch: @pitch1, start_date: '2016-02-01', end_date: '2016-03-01')
        FactoryGirl.create(
          :booking, pitch: @pitch1, start_date: '2016-03-15', end_date: '2016-04-01')

        @pitch2 = FactoryGirl.create(:pitch)
        FactoryGirl.create(
          :booking, pitch: @pitch2, start_date: '2016-06-20', end_date: '2016-07-01')
      end

      it 'returns true when pitch matches existing booking' do
        expect(@pitch1.booked?('2016-02-01', '2016-03-01')).to be_truthy
      end

      it 'returns true when pitch is contained in booking' do
        expect(@pitch1.booked?('2016-01-20', '2016-02-10')).to be_truthy
      end

      it 'returns true when pitch overlaps with two bookings' do
        expect(@pitch1.booked?('2016-02-20', '2016-03-20')).to be_truthy
      end

      it 'returns true when overlaps at the beginning' do
        expect(@pitch1.booked?('2016-02-20', '2016-03-10')).to be_truthy
      end

      it 'returns true when overlaps at the end' do
        expect(@pitch1.booked?('2016-01-20', '2016-02-10')).to be_truthy
      end

      it 'returns false when there is no overlaps' do
        expect(@pitch1.booked?('2016-03-05', '2016-03-10')).to be_falsey
      end

      it 'returns false when the last booking date matches the first date in given period' do
        expect(@pitch1.booked?('2016-03-01', '2016-03-10')).to be_falsey
      end

      it 'returns false when the last date in given period matches first day in booking' do
        expect(@pitch1.booked?('2016-03-05', '2016-03-15')).to be_falsey
      end

      it 'returns false when there is a match in other bookings' do
        expect(@pitch1.booked?('2016-06-25', '2016-07-01')).to be_falsey
      end
    end

  end

end
