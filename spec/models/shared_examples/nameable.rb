RSpec.shared_examples 'nameable' do

  let(:class_sym) { described_class.to_s.underscore.to_sym }

  describe 'name' do
    it 'cannot be blank' do
      [ '', nil ].each do |name|
        model = FactoryGirl.build(class_sym, name: name)
        expect(model).not_to be_valid
        expect(model.errors[:name]).to include("can't be blank")
      end
    end

    it 'must have at least 5 characters' do
      expect(FactoryGirl.build(class_sym, name: 'rodic')).to be_valid

      model = FactoryGirl.build(class_sym, name: 'shrt')
      expect(model).not_to be_valid
      expect(model.errors[:name]).to include('is too short (minimum is 5 characters)')
    end

    it 'cannot have more than 100 characters' do
      expect(FactoryGirl.build(class_sym, name: 'a' * 100)).to be_valid

      model = FactoryGirl.build(class_sym, name: 'a' * 101)
      expect(model).not_to be_valid
      expect(model.errors[:name]).to include('is too long (maximum is 100 characters)')
    end
  end
end
