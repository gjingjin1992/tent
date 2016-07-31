require 'rails_helper'

RSpec.describe Rate, type: :model do

  describe 'validations' do

    it 'passes with proper data' do
      expect(FactoryGirl.build(:rate)).to be_valid
    end

    describe 'from_date' do

      it 'must have proper form' do
        ['2016-07-21', '4 jan 2015', '19.06.1973'].each do |date|
          expect(
            FactoryGirl.build(:rate, from_date: date, to_date: '2050-01-01')
          ).to be_valid
        end

        ['', 'yesterday', '0.0.0'].each do |date|
          rate = FactoryGirl.build(:rate, from_date: date)
          expect(rate).not_to be_valid
          expect(rate.errors[:from_date]).to include('is not a valid date')
        end
      end

      it 'cannot overlap with another rate on same pitch' do
        pitch = FactoryGirl.create(:pitch)

        FactoryGirl.create(
          :rate, pitch: pitch, from_date: '2016-07-01', to_date: '2016-08-01'
        )

        rate = FactoryGirl.build(:rate, pitch: pitch, from_date: '2016-07-15', to_date: '2016-08-15')
        expect(rate).not_to be_valid
        expect(rate.errors[:from_date]).to include('overlaps with existing rate')
      end

      it 'can overlaps with itself' do
        pitch = FactoryGirl.create(:pitch)

        rate = FactoryGirl.create(
          :rate, pitch: pitch, from_date: '2016-07-01', to_date: '2016-08-01'
        )

        rate.from_date = '2016-07-01'
        rate.to_date = '2016-08-01'

        expect(rate).to be_valid

        rate.from_date = '2016-07-15'
        rate.to_date = '2016-07-20'

        expect(rate).to be_valid

        rate.from_date = '2016-06-15'
        rate.to_date = '2016-08-20'

        expect(rate).to be_valid
      end

      it 'overlap validation ignores rates on other pitches' do
        FactoryGirl.create(
          :rate, from_date: '2016-07-01', to_date: '2016-08-01'
        )

        expect(
          FactoryGirl.build(:rate, from_date: '2016-07-15', to_date: '2016-08-15')
        ).to be_valid
      end

      it 'cannot be after to_date' do
        rate = FactoryGirl.build(:rate, from_date: '2016-07-01', to_date: '2016-06-01')
        expect(rate).not_to be_valid
        expect(rate.errors[:from_date]).to include('must be before 2016-06-01')
      end
    end
  end

  describe 'to_date' do

    it 'must have proper form' do
      ['2016-07-21', '4 jan 2015', '19.06.1973'].each do |date|
        expect(
          FactoryGirl.build(:rate, from_date: '1970-01-01', to_date: date)
        ).to be_valid
      end

      ['', 'yesterday', '0.0.0'].each do |date|
        rate = FactoryGirl.build(:rate, to_date: date)
        expect(rate).not_to be_valid
        expect(rate.errors[:to_date]).to include('is not a valid date')
      end
    end

    it 'cannot overlap with another rate on same pitch' do
      pitch = FactoryGirl.create(:pitch)

      FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-07-01', to_date: '2016-08-01'
      )

      rate = FactoryGirl.build(:rate, pitch: pitch, from_date: '2016-06-15', to_date: '2016-07-15')
      expect(rate).not_to be_valid
      expect(rate.errors[:to_date]).to include('overlaps with existing rate')
    end

    it 'overlap validation ignores rates on other pitches' do
      FactoryGirl.create(
        :rate, from_date: '2016-07-01', to_date: '2016-08-01'
      )

      expect(
        FactoryGirl.build(:rate, from_date: '2016-06-15', to_date: '2016-07-15')
      ).to be_valid
    end

    it 'cannot be before before_date' do
      rate = FactoryGirl.build(:rate, from_date: '2016-07-01', to_date: '2016-06-01')
      expect(rate).not_to be_valid
      expect(rate.errors[:to_date]).to include('must be after 2016-07-01')
    end
  end

  describe 'dates' do
    it 'cannot contain existing rate' do
      pitch = FactoryGirl.create(:pitch)

      FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-07-01', to_date: '2016-08-01'
      )

      rate = FactoryGirl.build(
        :rate, pitch: pitch, from_date: '2016-06-15', to_date: '2016-08-15'
      )
      expect(rate).not_to be_valid
      expect(rate.errors[:from_date]).to include('overlaps with existing rate')
      expect(rate.errors[:to_date]).to include('overlaps with existing rate')
    end

    it 'cannot be contained in existing rate' do
      pitch = FactoryGirl.create(:pitch)

      FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-04-01', to_date: '2016-08-01'
      )

      rate = FactoryGirl.build(
        :rate, pitch: pitch, from_date: '2016-05-01', to_date: '2016-07-01'
      )
      expect(rate).not_to be_valid
      expect(rate.errors[:from_date]).to include('overlaps with existing rate')
      expect(rate.errors[:to_date]).to include('overlaps with existing rate')
    end

    it 'fails when they share date' do
      pitch = FactoryGirl.create(:pitch)

      FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-07-15', to_date: '2016-08-15'
      )

      rate = FactoryGirl.build(
        :rate, pitch: pitch, from_date: '2016-08-15', to_date: '2016-09-15'
      )

      expect(rate).not_to be_valid
      expect(rate.errors[:from_date]).to include('overlaps with existing rate')
    end

    it 'validates when rates are next to each other' do
      pitch = FactoryGirl.create(:pitch)

      FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-07-15', to_date: '2016-08-15'
      )

      rate = FactoryGirl.build(
        :rate, pitch: pitch, from_date: '2016-08-16', to_date: '2016-10-15'
      )

      expect(rate).to be_valid
    end
  end

  describe 'amount' do

    it 'cannot be blank' do
      ['', nil].each do |amount|
        site = FactoryGirl.build(:rate, amount: amount)
        expect(site).not_to be_valid
        expect(site.errors[:amount]).to include("can't be blank")
      end
    end

    it 'must be a non negative number' do
      [0, 1, 3.14, '15.0', 110, '235', 1_000_000].each do |num|
        expect(FactoryGirl.build(:rate, amount: num)).to be_valid
      end

      ['one', 'a lot', true].each do |num|
        pitch = FactoryGirl.build(:rate, amount: num)
        expect(pitch).not_to be_valid
        expect(pitch.errors[:amount]).to include('is not a number')
      end

      [-100, -0.00001].each do |num|
        pitch = FactoryGirl.build(:rate, amount: num)
        expect(pitch).not_to be_valid
        expect(pitch.errors[:amount]).to include('must be greater than or equal to 0')
      end
    end
  end

  describe 'associations' do

    it 'belongs_to pitch' do
      pitch = FactoryGirl.create(:pitch)
      rate  = FactoryGirl.build(:rate, pitch: pitch)

      expect(rate.pitch).to eq(pitch)
    end
  end

  describe 'scopes' do

    describe 'for_pitch' do

      it 'returns all rates for given pitch' do
        pitch = FactoryGirl.create(:pitch)
        rate1 = FactoryGirl.create(:rate, pitch: pitch)
        rate2 = FactoryGirl.create(:rate)
        rate3 = FactoryGirl.create(:rate, pitch: pitch)
        expect(Rate.for_pitch(pitch)).to match_array([rate1, rate3])
      end

      it 'returns empty relation when there are no rates for given pitch' do
        pitch = FactoryGirl.create(:pitch)
        rate1 = FactoryGirl.create(:rate)
        rate2 = FactoryGirl.create(:rate)
        rate3 = FactoryGirl.create(:rate)
        expect(Rate.for_pitch(pitch)).to match_array([])
      end
    end

    describe 'relevant_for_period' do

      before :each do
        @rate1 = FactoryGirl.create(:rate, from_date: '2016-01-01', to_date: '2016-01-31')
        @rate2 = FactoryGirl.create(:rate, from_date: '2016-02-01', to_date: '2016-02-29')
        @rate3 = FactoryGirl.create(:rate, from_date: '2016-03-01', to_date: '2016-03-31')
        @rate4 = FactoryGirl.create(:rate, from_date: '2016-04-01', to_date: '2016-04-30')
        @rate5 = FactoryGirl.create(:rate, from_date: '2016-05-01', to_date: '2016-05-31')
      end

      it 'returns only rates relevant for given start and end date' do
        result = Rate.relevant_for_period('2016-02-15', '2016-04-15')
        expect(result).to match_array([@rate2, @rate3, @rate4])
      end

      it 'returns empty relation when there are no relevant rates' do
        result = Rate.relevant_for_period('2016-08-15', '2016-09-15')
        expect(result).to match_array([])
      end
    end
  end

end
