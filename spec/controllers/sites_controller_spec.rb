require 'rails_helper'

RSpec.describe SitesController, type: :controller do

  describe 'GET #show' do
    it 'returns http success' do
      site = FactoryGirl.create(:site)
      get :show, id: site.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do

    describe 'owner not signed in' do
      it 'returns to owner signin page' do
        expect(get :new).to redirect_to(new_owner_session_path)
      end
    end

    describe 'owner is signed in' do

      let(:owner) { FactoryGirl.create(:owner) }

      before do
        sign_in owner, scope: :owner
      end

      it 'returns http success' do
        expect(get :new).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do

    let(:wifi) { FactoryGirl.create(:amenity, name: 'WiFi') }
    let(:shop) { FactoryGirl.create(:amenity, name: 'shop') }
    let(:parking) { FactoryGirl.create(:amenity, name: 'parking') }

    let(:valid_params) {{
      name: 'My site',
      email: 'contect@my-site.com',
      general_desc: 'Short site description',
      detailed_desc: 'More detailed site description',
      arrival_time: '12:00',
      departure_time: '10:00',
      type: site_type.id,
      address1: 'Main street 24.',
      country: 'United Kingdom',
      county: 'Cornwall',
      city: 'St Ives',
      town: 'St Ives',
      postcode: 'TR26 2DS',
      telephone: '0905 252 2250',
      latitude: 51.497837,
      longitude: -0.079693,
      amenity_ids: [ wifi.id, parking.id ]
    }}

    let(:site_type) { FactoryGirl.create(:site_type) }

    describe 'owner not signed in' do
      it 'returns to signup page' do
        expect{ post :create, site: valid_params }.not_to change{ Site.count }
        expect(response).to redirect_to(new_owner_session_path)
      end
    end

    describe 'owner signed in' do

      let(:owner) { FactoryGirl.create(:owner) }

      before do
        sign_in owner, scope: :owner
      end

      it 'new site with valid params' do
        expect{ post :create, site: valid_params }.to change{ Site.count }.from(0).to(1)
        expect(Site.last.amenities).to match_array([wifi, parking])
      end

      it "doesn't create a site when params are invalid" do
        expect{ post :create, site: {name: ''} }.not_to change{ Site.count }
        expect(response).to render_template('new')
      end
    end

  end

  describe 'GET #edit' do

    let(:owner1) { FactoryGirl.create(:owner) }
    let(:owner2) { FactoryGirl.create(:owner) }
    let(:site)   { FactoryGirl.create(:site, owner: owner1) }

    describe 'owner not signed in' do
      it 'redirects to owner signin page' do
        expect(get :edit, id: site.id).to redirect_to(new_owner_session_path)
      end
    end

    describe 'wrong owner is signed in' do

      before do
        sign_in owner2, scope: :owner
      end

      it 'redirects to /sites' do
        expect(get :edit, id: site.id).to redirect_to(sites_path)
      end
    end

    describe 'correct owner is signed in' do
      before do
        sign_in owner1, scope: :owner
      end

      it 'is success' do
        expect(get :edit, id: site.id).to have_http_status(:success)
      end
    end
  end

  describe 'PATCH #update' do

    let(:owner1) { FactoryGirl.create(:owner) }
    let(:owner2) { FactoryGirl.create(:owner) }
    let(:site)   { FactoryGirl.create(:site, owner: owner1) }
    let(:valid_params) { { name: 'New site name', address2: 'main rd', telephone: '333-4444' } }

    describe 'owner not signed in' do
      it 'redirects to owner signin page' do
        expect(patch :update, id: site.id, site: valid_params).to redirect_to(new_owner_session_path)
      end
    end

    describe 'wrong owner is signed in' do

      before do
        sign_in owner2, scope: :owner
      end

      it 'redirects to /sites' do
        expect(patch :update, id: site.id, site: valid_params).to redirect_to(sites_path)
      end
    end

    describe 'correct owner is signed in' do
      before do
        sign_in owner1, scope: :owner
      end

      it 'is success with valid params' do
        expect(patch :update, id: site.id, site: valid_params).to redirect_to(sites_path)
        site.reload
        valid_params.keys.each do |p|
          expect(site[p]).to eq(valid_params[p])
        end
      end

      it 'is failure with invalid params' do
        expect(patch :update, id: site.id, site: {name: ''}).to render_template('edit')
      end
    end
  end

end
