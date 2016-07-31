require 'rails_helper'

RSpec.describe Booking, type: :model do

  describe 'validations' do

    it 'passes with proper data' do
      expect(FactoryGirl.build(:booking)).to be_valid
    end

    describe 'start_date' do

      it 'must have proper form' do
        ['2016-07-21', '4 jan 2015', '19.06.1973'].each do |date|
          expect(
            FactoryGirl.build(:booking, start_date: date, end_date: '2050-01-01')
          ).to be_valid
        end

        ['', 'yesterday', '0.0.0'].each do |date|
          booking = FactoryGirl.build(:booking, start_date: date)
          expect(booking).not_to be_valid
          expect(booking.errors[:start_date]).to include('is not a valid date')
        end
      end

      it 'cannot overlap with another booking on same pitch' do
        pitch = FactoryGirl.create(:pitch)

        FactoryGirl.create(
          :booking, pitch: pitch, start_date: '2016-07-01', end_date: '2016-08-01'
        )

        booking = FactoryGirl.build(
          :booking, pitch: pitch, start_date: '2016-07-15', end_date: '2016-08-15'
        )
        expect(booking).not_to be_valid
        expect(booking.errors[:start_date]).to include('pitch is occupied')
      end

      it 'overlap validation ignores bookings on other pitches' do
        FactoryGirl.create(
          :booking, start_date: '2016-07-01', end_date: '2016-08-01'
        )

        expect(
          FactoryGirl.build(:booking, start_date: '2016-07-15', end_date: '2016-08-15')
        ).to be_valid
      end

      it 'cannot be after end_date' do
        booking = FactoryGirl.build(:booking, start_date: '2016-07-01', end_date: '2016-06-01')
        expect(booking).not_to be_valid
        expect(booking.errors[:start_date]).to include('must be before 2016-06-01')
      end
    end

    describe 'end_date' do

      it 'must have proper form' do
        ['2016-07-21', '4 jan 2015', '19.06.1973'].each do |date|
          expect(
            FactoryGirl.build(:booking, start_date: '1970-01-01', end_date: date)
          ).to be_valid
        end

        ['', 'yesterday', '0.0.0'].each do |date|
          booking = FactoryGirl.build(:booking, end_date: date)
          expect(booking).not_to be_valid
          expect(booking.errors[:end_date]).to include('is not a valid date')
        end
      end

      it 'cannot overlap with another booking on same pitch' do
        pitch = FactoryGirl.create(:pitch)

        FactoryGirl.create(
          :booking, pitch: pitch, start_date: '2016-07-01', end_date: '2016-08-01'
        )

        booking = FactoryGirl.build(
          :booking, pitch: pitch, start_date: '2016-06-15', end_date: '2016-07-15'
        )
        expect(booking).not_to be_valid
        expect(booking.errors[:end_date]).to include('pitch is occupied')
      end

      it 'can overlaps with itself' do
        pitch = FactoryGirl.create(:pitch)

        booking = FactoryGirl.create(
          :booking, pitch: pitch, start_date: '2016-07-01', end_date: '2016-08-01'
        )

        booking.start_date = '2016-07-01'
        booking.end_date = '2016-08-01'

        expect(booking).to be_valid

        booking.start_date = '2016-07-15'
        booking.end_date = '2016-07-20'

        expect(booking).to be_valid

        booking.start_date = '2016-06-15'
        booking.end_date = '2016-08-20'

        expect(booking).to be_valid
      end

      it 'overlap validation ignores bookings on other pitches' do
        FactoryGirl.create(
          :booking, start_date: '2016-07-01', end_date: '2016-08-01'
        )

        expect(
          FactoryGirl.build(:booking, start_date: '2016-07-15', end_date: '2016-08-15')
        ).to be_valid
      end

      it 'cannot be before start_date' do
        booking = FactoryGirl.build(:booking, start_date: '2016-07-01', end_date: '2016-06-01')
        expect(booking).not_to be_valid
        expect(booking.errors[:end_date]).to include('must be after 2016-07-01')
      end
    end

    describe 'dates' do

      it 'cannot contain existing booking' do
        pitch = FactoryGirl.create(:pitch)

        FactoryGirl.create(
          :booking, pitch: pitch, start_date: '2016-07-01', end_date: '2016-08-01'
        )

        booking = FactoryGirl.build(
          :booking, pitch: pitch, start_date: '2016-06-15', end_date: '2016-08-15'
        )
        expect(booking).not_to be_valid
        expect(booking.errors[:start_date]).to include('pitch is occupied')
        expect(booking.errors[:end_date]).to include('pitch is occupied')
      end

      it 'cannot be contained in existing booking' do
        pitch = FactoryGirl.create(:pitch)

        FactoryGirl.create(
          :booking, pitch: pitch, start_date: '2016-04-01', end_date: '2016-08-01'
        )

        booking = FactoryGirl.build(
          :booking, pitch: pitch, start_date: '2016-05-01', end_date: '2016-07-01'
        )
        expect(booking).not_to be_valid
        expect(booking.errors[:start_date]).to include('pitch is occupied')
        expect(booking.errors[:end_date]).to include('pitch is occupied')
      end

      it 'validates when bookings are next to each other' do
        pitch = FactoryGirl.create(:pitch)

        FactoryGirl.create(
          :booking, pitch: pitch, start_date: '2016-07-15', end_date: '2016-08-15'
        )

        booking = FactoryGirl.build(
          :booking, pitch: pitch, start_date: '2016-08-15', end_date: '2016-09-15'
        )

        expect(booking).to be_valid
      end
    end
  end

  describe 'associations' do

    it 'belongs_to booker' do
      booker  = FactoryGirl.create(:booker)
      booking = FactoryGirl.create(:booking, booker: booker)
      expect(booking.booker).to eq(booker)
    end

    it 'belongs_to pitch' do
      pitch   = FactoryGirl.create(:pitch)
      booking = FactoryGirl.create(:booking, pitch: pitch)
      expect(booking.pitch).to eq(pitch)
    end
  end
end
