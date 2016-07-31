require 'rails_helper'

RSpec.describe SiteAmenity, type: :model do

  describe 'validations' do
    it 'passes with proper data' do
      expect(FactoryGirl.build(:site_amenity)).to be_valid
    end
  end

  describe 'associations' do

    it 'belongs to site' do
      site = FactoryGirl.create(:site)
      site_amenity = FactoryGirl.create(:site_amenity, site: site)
      expect(site_amenity.site).to eq(site)
    end

    it 'belongs_to amenity' do
      amenity = FactoryGirl.create(:amenity)
      site_amenity = FactoryGirl.create(:site_amenity, amenity: amenity)
      expect(site_amenity.amenity).to eq(amenity)
    end
  end
end
