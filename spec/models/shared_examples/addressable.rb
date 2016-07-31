RSpec.shared_examples 'addressable' do

  let(:class_sym) { described_class.to_s.underscore.to_sym }

  describe 'address1' do
    it 'cannot be blank' do
      [ '', nil ].each do |address1|
        model = FactoryGirl.build(class_sym, address1: address1)
        expect(model).not_to be_valid
        expect(model.errors[:address1]).to include("can't be blank")
      end
    end

    it 'cannot have more than 300 chars' do
      expect(FactoryGirl.build(class_sym, address1: 'a' * 300)).to be_valid
      model = FactoryGirl.build(class_sym, address1: 'a' * 301)
      expect(model).not_to be_valid
      expect(model.errors[:address1]).to include('is too long (maximum is 300 characters)')
    end
  end

  describe 'address2' do
    it 'can be blank' do
      [ '', nil ].each do |address|
        expect(FactoryGirl.build(class_sym, address2: address)).to be_valid
      end
    end

    it 'cannot have more than 300 chars' do
      expect(FactoryGirl.build(class_sym, address2: 'a' * 300)).to be_valid
      model = FactoryGirl.build(class_sym, address2: 'a' * 301)
      expect(model).not_to be_valid
      expect(model.errors[:address2]).to include('is too long (maximum is 300 characters)')
    end
  end

  describe 'address3' do
    it 'can be blank' do
      [ '', nil ].each do |address|
        expect(FactoryGirl.build(class_sym, address3: address)).to be_valid
      end
    end

    it 'cannot have more than 300 chars' do
      expect(FactoryGirl.build(class_sym, address3: 'a' * 300)).to be_valid
      model = FactoryGirl.build(class_sym, address3: 'a' * 301)
      expect(model).not_to be_valid
      expect(model.errors[:address3]).to include('is too long (maximum is 300 characters)')
    end
  end

  describe 'country' do
    it 'cannot be blank' do
      [ '', nil ].each do |country|
        model = FactoryGirl.build(class_sym, country: country)
        expect(model).not_to be_valid
        expect(model.errors[:country]).to include("can't be blank")
      end
    end

    it 'must have at least two chars' do
      expect(FactoryGirl.build(class_sym, country: 'UK')).to be_valid

      model = FactoryGirl.build(class_sym, country: 'Z')
      expect(model).not_to be_valid
      expect(model.errors[:country]).to include('is too short (minimum is 2 characters)')
    end
  end

  describe 'county' do
    it 'cannot be blank' do
      [ '', nil ].each do |county|
        model = FactoryGirl.build(class_sym, county: county)
        expect(model).not_to be_valid
        expect(model.errors[:county]).to include("can't be blank")
      end
    end
  end

  describe 'city' do
    it 'cannot be blank' do
      [ '', nil ].each do |city|
        model = FactoryGirl.build(class_sym, city: city)
        expect(model).not_to be_valid
        expect(model.errors[:city]).to include("can't be blank")
      end
    end
  end

  describe 'town' do
    it 'cannot be blank' do
      [ '', nil ].each do |town|
        model = FactoryGirl.build(class_sym, town: town)
        expect(model).not_to be_valid
        expect(model.errors[:town]).to include("can't be blank")
      end
    end
  end

  describe 'postcode' do
    it 'cannot be blank' do
      [ '', nil ].each do |postcode|
        model = FactoryGirl.build(class_sym, postcode: postcode)
        expect(model).not_to be_valid
        expect(model.errors[:postcode]).to include("can't be blank")
      end
    end
  end

  describe 'telephone' do
    it 'cannot be blank' do
      [ '', nil ].each do |telephone|
        model = FactoryGirl.build(class_sym, telephone: telephone)
        expect(model).not_to be_valid
        expect(model.errors[:telephone]).to include("can't be blank")
      end
    end
  end

end
