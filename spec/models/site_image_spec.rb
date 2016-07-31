require 'rails_helper'

RSpec.describe SiteImage, type: :model do

  describe 'validations' do

    it 'validates with proper data' do
      expect(FactoryGirl.create(:site_image)).to be_valid
    end

  end

  describe 'associations' do

    it 'belongs_to site' do
      site = FactoryGirl.create(:site)
      site_image = FactoryGirl.create(:site_image, site: site)
      expect(site_image.site).to eq(site)
    end
  end
end
