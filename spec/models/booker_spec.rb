require 'rails_helper'

RSpec.describe Booker, type: :model do

  describe 'validations' do

    it 'passes with proper data' do
      expect(FactoryGirl.build(:booker)).to be_valid
    end

    it_behaves_like 'emailable'

    describe 'email' do
      it 'must be uniqe' do
        email = 'test@example.com'
        FactoryGirl.create(:booker, email: email)

        booker = FactoryGirl.build(:booker, email: email)
        expect(booker).not_to be_valid
        expect(booker.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do

    it 'has many bookings' do
      booker   = FactoryGirl.create(:booker)
      booking1 = FactoryGirl.create(:booking, booker: booker)
      booking2 = FactoryGirl.create(:booking)
      booking3 = FactoryGirl.create(:booking, booker: booker)
      expect(booker.bookings).to match_array([booking1, booking3])
    end
  end
end
