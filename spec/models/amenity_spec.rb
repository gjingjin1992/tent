require 'rails_helper'

RSpec.describe Amenity, type: :model do

  describe 'validations' do

    it 'passes with proper data' do
      expect(FactoryGirl.build(:amenity)).to be_valid
    end

    describe 'name' do

      it 'cannot be blank' do
        ['', nil].each do |name|
          amenity = FactoryGirl.build(:amenity, name: name)
          expect(amenity).not_to be_valid
          expect(amenity.errors[:name]).to include("can't be blank")
        end
      end

      it 'must be unique' do
        name = 'WiFi'

        FactoryGirl.create(:amenity, name: name)
        amenity1 = FactoryGirl.build(:amenity, name: name)

        expect(amenity1).not_to be_valid
        expect(amenity1.errors[:name]).to include('has already been taken')

        name_up = name.upcase
        expect(name_up).not_to eq(name)

        amenity2 = FactoryGirl.build(:amenity, name: name_up)
        expect(amenity2).not_to be_valid
        expect(amenity2.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do

    it 'has_many site_amenities' do
      amenity = FactoryGirl.create(:amenity)
      site_amenity1 = FactoryGirl.create(:site_amenity, amenity: amenity)
      site_amenity2 = FactoryGirl.create(:site_amenity)
      site_amenity3 = FactoryGirl.create(:site_amenity, amenity: amenity)
      expect(amenity.site_amenities).to match_array([site_amenity1, site_amenity3])
    end

    it 'has_many sites through site_amenities' do
      amenity1 = FactoryGirl.create(:amenity)
      amenity2 = FactoryGirl.create(:amenity)
      site1 = FactoryGirl.create(:site)
      site2 = FactoryGirl.create(:site)
      site3 = FactoryGirl.create(:site)
      site4 = FactoryGirl.create(:site)

      FactoryGirl.create(:site_amenity, amenity: amenity1, site: site1)
      FactoryGirl.create(:site_amenity, amenity: amenity1, site: site2)
      FactoryGirl.create(:site_amenity, amenity: amenity1, site: site3)
      FactoryGirl.create(:site_amenity, amenity: amenity2, site: site4)

      expect(amenity1.sites).to match_array([site1, site2, site3])
      expect(amenity2.sites).to match_array([site4])
    end
  end
end
