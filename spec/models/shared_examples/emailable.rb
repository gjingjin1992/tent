RSpec.shared_examples 'emailable' do

  let(:class_sym) { described_class.to_s.underscore.to_sym }

  it 'cannot be blank' do
    [ '', nil ].each do |email|
      model = FactoryGirl.build(class_sym, email: email)
      expect(model).not_to be_valid
      expect(model.errors[:email]).to include("can't be blank")
    end
  end

  it 'has to be in proper format' do
    [
      'email@example.com',
      'firstname.lastname@example.com',
      'email@subdomain.example.com',
      'firstname+lastname@example.com',
      'email@123.123.123.123'
    ].each do |valid_email|
      expect(FactoryGirl.build(class_sym, email: valid_email)).to be_valid
    end

    [
      'plainaddress',
      '#@%^%#$@#$@#.com',
      '@example.com',
      'Joe Smith <email@example.com>',
      'email.example.com',
      'email@example@example.com'
    ].each do |invalid_email|
      model = FactoryGirl.build(class_sym, email: invalid_email)
      expect(model).not_to be_valid
      expect(model.errors[:email]).to include('is invalid')
    end
  end
end
