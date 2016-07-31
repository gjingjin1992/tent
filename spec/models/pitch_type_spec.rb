require 'rails_helper'

RSpec.describe PitchType, type: :model do

  describe 'validations' do

    it 'passes with proper data' do
      expect(FactoryGirl.build(:pitch_type)).to be_valid
    end

    describe 'name' do

      it 'cannot be blank' do
        [ '', nil ].each do |name|
          site = FactoryGirl.build(:pitch_type, name: name)
          expect(site).not_to be_valid
          expect(site.errors[:name]).to include("can't be blank")
        end
      end

      it 'must be unique' do
        name = 'Yurt'

        FactoryGirl.create(:pitch_type, name: name)
        pitch_type1 = FactoryGirl.build(:pitch_type, name: name)

        expect(pitch_type1).not_to be_valid
        expect(pitch_type1.errors[:name]).to include('has already been taken')

        name_up = name.upcase
        expect(name_up).not_to eq(name)

        pitch_type2 = FactoryGirl.build(:pitch_type, name: name_up)
        expect(pitch_type2).not_to be_valid
        expect(pitch_type2.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do

    it 'has_many pitches' do
      pitch_type = FactoryGirl.create(:pitch_type)
      pitch1 = FactoryGirl.create(:pitch, type: pitch_type)
      pitch2 = FactoryGirl.create(:pitch)
      pitch3 = FactoryGirl.create(:pitch, type: pitch_type)

      expect(pitch_type.pitches).to match_array([pitch1, pitch3])
    end
  end

end
