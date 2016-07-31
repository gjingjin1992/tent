require 'rails_helper'

RSpec.describe 'PitchPriceCalculator' do

  describe '#date_diff_in_nights' do

    it 'returns correct difference' do
      pitch = FactoryGirl.create(:pitch)
      calculator = PitchPriceCalculator.new(pitch, '2016-02-15', '2016-02-20')

      date1 = Date.parse('2016-06-10')
      date2 = Date.parse('2016-06-12')

      expect(calculator.send(:date_diff_in_nights, date1, date2)).to eq(2)
    end
  end

  describe '#relevant_rates' do

    it 'retturns correct rates' do
      pitch = FactoryGirl.create(:pitch)
      rate1 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-01-01', to_date: '2016-01-31')
      rate2 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-02-01', to_date: '2016-02-29')
      rate3 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-03-01', to_date: '2016-03-31')
      rate4 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-04-01', to_date: '2016-04-30')
      rate5 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-05-01', to_date: '2016-05-31')

      calculator = PitchPriceCalculator.new(pitch, '2016-02-15', '2016-03-20')

      expect(calculator.send(:relevant_rates)).to match_array([rate2, rate3])
    end
  end

  describe '#normalized_rates' do

    it 'removes days from rate that are not covered by given period' do
      pitch = FactoryGirl.create(:pitch)
      rate1 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-01-01', to_date: '2016-01-31')
      rate2 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-02-01', to_date: '2016-02-29')
      rate3 = FactoryGirl.create(
        :rate, pitch: pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(pitch, '2016-01-19', '2016-03-04')
      result = calculator.send(:normalized_rates)

      expect(result.first.from_date).to eq(Date.parse('2016-01-19'))
      expect(result.first.to_date).to eq(Date.parse('2016-01-31'))
      expect(result.first.period_in_nights).to eq(13)

      expect(result.second.from_date).to eq(Date.parse('2016-02-01'))
      expect(result.second.to_date).to eq(Date.parse('2016-02-29'))
      expect(result.second.period_in_nights).to eq(29)

      expect(result.third.from_date).to eq(Date.parse('2016-03-01'))
      expect(result.third.to_date).to eq(Date.parse('2016-03-04'))
      expect(result.third.period_in_nights).to eq(3)
    end
  end

  describe '#nights_covered_by_rates_in_period' do

    before :each do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-01-01', to_date: '2016-01-31')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')
    end

    it 'returns 0 when from and to are same' do
      calculator = PitchPriceCalculator.new(@pitch, '2016-01-01', '2016-01-01')
      expect(calculator.send(:nights_covered_by_rates_in_period)).to eq(0)
    end

    it 'returns 1 when there is one day diff' do
      calculator = PitchPriceCalculator.new(@pitch, '2016-01-01', '2016-01-02')
      expect(calculator.send(:nights_covered_by_rates_in_period)).to eq(1)
    end

    it 'caluclates correct difference for days in same rate' do
      calculator = PitchPriceCalculator.new(@pitch, '2016-01-5', '2016-01-10')
      expect(calculator.send(:nights_covered_by_rates_in_period)).to eq(5)
    end

    it 'calculates correct difference when period spans over entire rate' do
      calculator = PitchPriceCalculator.new(@pitch, '2016-01-01', '2016-01-31')
      expect(calculator.send(:nights_covered_by_rates_in_period)).to eq(30)
    end

    it 'calculates correct difference for days in two different rates' do
      calculator = PitchPriceCalculator.new(@pitch, '2016-01-25', '2016-02-04')
      expect(calculator.send(:nights_covered_by_rates_in_period)).to eq(10)
    end

    it 'calculates correct difference for days in three different rates' do
      calculator = PitchPriceCalculator.new(@pitch, '2016-01-25', '2016-03-04')
      expect(calculator.send(:nights_covered_by_rates_in_period)).to eq(39)
    end

    it 'takes leap year into account' do
      calculator = PitchPriceCalculator.new(@pitch, '2016-02-25', '2016-03-04')
      expect(calculator.send(:nights_covered_by_rates_in_period)).to eq(8)
    end
  end

  describe '#covered_by_rates?' do

    it 'returns false when period is not covered by any rate' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-01-01', to_date: '2016-01-31')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-04-01', '2016-04-10')
      expect(calculator).not_to be_covered_by_rates
    end

    it 'returns false when period is only partialy covered at the beginning' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-03-01', '2016-04-02')
      expect(calculator).not_to be_covered_by_rates
    end

    it 'returns false when period is only partialy covered at the end' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-01-31', '2016-03-15')
      expect(calculator).not_to be_covered_by_rates
    end

    it 'returns false when there is a hole in the middle' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-01-01', to_date: '2016-01-31')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-01-15', '2016-03-15')
      expect(calculator).not_to be_covered_by_rates
    end

    it 'returns true when period is equal to single rate' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-01-01', to_date: '2016-01-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-01-01', '2016-01-31')
      expect(calculator).to be_covered_by_rates
    end

    it 'returns true when period starts at the beginning of single rate' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-01-01', to_date: '2016-01-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-01-01', '2016-01-10')
      expect(calculator).to be_covered_by_rates
    end

    it 'returns true when period ends at the end of single rate' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-01-01', to_date: '2016-01-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-01-15', '2016-01-31')
      expect(calculator).to be_covered_by_rates
    end

    it 'returns true when period is contained in single rate' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-01-01', to_date: '2016-01-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-01-04', '2016-01-10')
      expect(calculator).to be_covered_by_rates
    end

    it 'returns true when period is equal to two rates' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-02-01', '2016-03-31')
      expect(calculator).to be_covered_by_rates
    end

    it 'returns true when period is contained in two rates' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29')
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-02-21', '2016-03-01')
      expect(calculator).to be_covered_by_rates
    end

    it 'returns true when last day is not covered by any rate (but night is)' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-03-01', '2016-04-01')
      expect(calculator).to be_covered_by_rates
    end
  end

  describe '#calculate' do

    it 'returns nil when period is not covered by rates' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29')

      calculator = PitchPriceCalculator.new(@pitch, '2016-03-01', '2016-04-01')
      expect(calculator.calculate).to be_nil
    end

    it 'returns nil when it is only partialy covered' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31')

      calculator = PitchPriceCalculator.new(@pitch, '2016-03-01', '2016-04-05')
      expect(calculator.calculate).to be_nil
    end

    it 'calculates correct price when period is in single rate' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29', amount: 10)

      calculator = PitchPriceCalculator.new(@pitch, '2016-02-10', '2016-02-15')
      expect(calculator.calculate).to eq(50)
    end

    it 'calculates correct price for multiple guests when period is in single rate' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29', amount: 10)

      calculator = PitchPriceCalculator.new(@pitch, '2016-02-10', '2016-02-15', 10)
      expect(calculator.calculate).to eq(500)
    end

    it 'calculates correct price when period is multiple rates' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29', amount: 10)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31', amount: 5)

      calculator = PitchPriceCalculator.new(@pitch, '2016-02-25', '2016-03-5')
      expect(calculator.calculate).to eq(70)
    end

    it 'calculates correct price for multiple guests when period is multiple rates' do
      @pitch = FactoryGirl.create(:pitch)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-02-01', to_date: '2016-02-29', amount: 10)
      FactoryGirl.create(
        :rate, pitch: @pitch, from_date: '2016-03-01', to_date: '2016-03-31', amount: 5)

      calculator = PitchPriceCalculator.new(@pitch, '2016-02-25', '2016-03-5', 4)
      expect(calculator.calculate).to eq(280)
    end
  end
end
