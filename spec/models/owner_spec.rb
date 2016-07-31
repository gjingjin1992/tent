require 'rails_helper'

RSpec.describe Owner, type: :model do

  describe 'validations' do

    it 'validates with proper data' do
      expect(FactoryGirl.build(:owner)).to be_valid
    end

    it_behaves_like 'nameable'
    it_behaves_like 'emailable'

    describe 'email' do
      it 'must be uniqe' do
        email = 'test@example.com'
        FactoryGirl.create(:owner, email: email)

        owner = FactoryGirl.build(:owner, email: email)
        expect(owner).not_to be_valid
        expect(owner.errors[:email]).to include('has already been taken')
      end
    end

    it_behaves_like 'addressable'
  end

  describe 'associations' do

    it 'has many sites' do
      owner = FactoryGirl.create(:owner)
      site1 = FactoryGirl.create(:site, owner: owner)
      site2 = FactoryGirl.create(:site, owner: owner)

      expect(owner.sites).to match_array([site1, site2])
    end
  end
end
