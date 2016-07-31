require 'rails_helper'

RSpec.describe Owners::RegistrationsController, type: :controller do

  let(:valid_params) {{
    name: 'John Doe',
    email: 'johndoe@example.com',
    password: 'supersecret',
    password_confirmation: 'supersecret',
    address1: 'Main street 24.',
    country: 'United Kingdom',
    county: 'Cornwall',
    city: 'St Ives',
    town: 'St Ives',
    postcode: 'TR26 2DS',
    telephone: '0905 252 2250'

  }}

  describe 'create' do

    before do
      @request.env["devise.mapping"] = Devise.mappings[:owner]
    end

    it 'new booker with proper params' do
      expect{ post :create, owner: valid_params }.to change{ Owner.count }.from(0).to(1)

      owner = Owner.last

      expect(owner.name).to eq(valid_params[:name])
      expect(owner.email).to eq(valid_params[:email])
      expect(owner.address1).to eq(valid_params[:address1])
      expect(owner.country).to eq(valid_params[:country])
      expect(owner.county).to eq(valid_params[:county])
      expect(owner.city).to eq(valid_params[:city])
      expect(owner.town).to eq(valid_params[:town])
      expect(owner.postcode).to eq(valid_params[:postcode])
      expect(owner.telephone).to eq(valid_params[:telephone])
    end

    it 'fails to create when any of params is missing' do
      valid_params.keys.each do |key|
        if key != :password_confirmation
          invalid_params = valid_params.clone
          invalid_params[key] = nil
          expect{ post :create, owner: invalid_params }.not_to change{ Owner.count }
        end
      end
    end
  end

end
