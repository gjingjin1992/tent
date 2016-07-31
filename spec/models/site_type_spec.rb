require 'rails_helper'

RSpec.describe SiteType, type: :model do
  describe 'validations' do

    it 'passes with proper data' do
      expect(FactoryGirl.build(:site_type)).to be_valid
    end

    describe 'name' do

      it 'cannot be blank' do
        [ '', nil ].each do |name|
          site = FactoryGirl.build(:site_type, name: name)
          expect(site).not_to be_valid
          expect(site.errors[:name]).to include("can't be blank")
        end
      end

      it 'must be unique' do
        name = 'Touring Park'

        FactoryGirl.create(:site_type, name: name)
        site1 = FactoryGirl.build(:site_type, name: name)

        expect(site1).not_to be_valid
        expect(site1.errors[:name]).to include('has already been taken')

        name_up = name.upcase
        expect(name_up).not_to eq(name)

        site2 = FactoryGirl.build(:site_type, name: name_up)
        expect(site2).not_to be_valid
        expect(site2.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do

    it 'has many sites through site_type_assignments' do
      site_type = FactoryGirl.create(:site_type)
      site1 = FactoryGirl.create(:site, type: site_type)
      site2 = FactoryGirl.create(:site)
      site3 = FactoryGirl.create(:site, type: site_type)

      expect(site_type.sites).to match_array([site1, site3])
    end
  end
end
