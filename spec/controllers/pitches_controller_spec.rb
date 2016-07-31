require 'rails_helper'

RSpec.describe PitchesController, type: :controller do

  let(:owner) { FactoryGirl.create(:owner) }
  let(:site)  { FactoryGirl.create(:site, owner: owner) }
  let(:pitch) { FactoryGirl.create(:pitch, site: site) }

  let(:invalid_owner) { FactoryGirl.create(:owner) }
  let(:invalid_site)  { FactoryGirl.create(:pitch) }

  describe 'GET #new' do

    describe 'owner not signed in' do
      it 'redirects to owner signin page' do
        expect(get :new, site_id: site.id).to redirect_to(new_owner_session_path)
      end
    end

    describe 'owner is signed in' do

      describe 'invalid owner' do

        before do
          sign_in invalid_owner, scope: :owner
        end

        it 'get redirected to /sites' do
          expect(get :new, site_id: site.id).to redirect_to(sites_path)
        end
      end

      describe 'valid owner' do

        before do
          sign_in owner, scope: :owner
        end

        it 'gets the form' do
          expect(get :new, site_id: site.id).to have_http_status(:success)
        end
      end
    end
  end

  describe 'POST #create' do

    let(:caravan) { FactoryGirl.create(:pitch_type, name: 'caravan') }

    let(:valid_params) {{
      name: 'Testing pitch',
      pitch_type_id: caravan.id,
      max_persons: 4,
      length: 3,
      width: 4.5,
      rates_attributes: [
        {from_date: '2016-01-01', to_date: '2016-05-30', amount: 10},
        {from_date: '2016-06-01', to_date: '2016-12-31', amount: 20}
      ]
    }}

    describe 'owner not signed in' do

      it 'redirects to owner signin page' do
        expect{post :create, site_id: site.id, pitch: valid_params}.not_to change{Pitch.count}
        expect(response).to redirect_to(new_owner_session_path)
      end
    end

    describe 'invalid owner' do

      before do
        sign_in invalid_owner, scope: :owner
      end

      it 'get redirected to /sites' do
        expect{post :create, site_id: site.id, pitch: valid_params}.not_to change{Pitch.count}
        expect(response).to redirect_to(sites_path)
      end
    end

    describe 'valid owner' do

      before do
        sign_in owner, scope: :owner
      end

      it 'creates new pitch' do
        expect{post :create, site_id: site.id, pitch: valid_params}.to change{Pitch.count}.from(0).to(1)

        pitch = Pitch.last

        expect(pitch.name).to eq(valid_params[:name])
        expect(pitch.type).to eq(caravan)
        expect(pitch.max_persons).to eq(valid_params[:max_persons])
        expect(pitch.width).to eq(valid_params[:width])
        expect(pitch.length).to eq(valid_params[:length])

        expect(pitch.rates.count).to eq(2)
        expect(pitch.rates.first.amount).to eq(valid_params[:rates_attributes][0][:amount])
        expect(pitch.rates.first.from_date).to eq(Date.parse valid_params[:rates_attributes][0][:from_date])
        expect(pitch.rates.first.to_date).to eq(Date.parse valid_params[:rates_attributes][0][:to_date])
        expect(pitch.rates.second.amount).to eq(valid_params[:rates_attributes][1][:amount])
        expect(pitch.rates.second.from_date).to eq(Date.parse valid_params[:rates_attributes][1][:from_date])
        expect(pitch.rates.second.to_date).to eq(Date.parse valid_params[:rates_attributes][1][:to_date])

      end
    end
  end

  describe 'GET #edit' do

    describe 'owner not signed in' do
      it 'redirects to owner signin page' do
        expect(get :edit, site_id: site.id, id: pitch.id).to redirect_to(new_owner_session_path)
      end
    end

    describe 'owner is signed in' do

      describe 'invalid owner' do

        before do
          sign_in invalid_owner, scope: :owner
        end

        it 'get redirected to /sites' do
          expect(get :edit, site_id: site.id, id: pitch.id).to redirect_to(sites_path)
        end
      end

      describe 'valid owner' do

        before do
          sign_in owner, scope: :owner
        end

        it 'gets the form when pitch belongs to the site' do
          expect(get :new, site_id: site.id, id: pitch.id).to have_http_status(:success)
        end

        it 'raises an error when pitch does not belong to the site' do
          expect{get :new, site_id: invalid_site.id, id: pitch.id}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

  end

  describe 'PATCH #update' do

    let(:pod) { FactoryGirl.create(:pitch_type, name: 'pod') }

    let(:valid_params) {{
      name: 'Testing pitch edit',
      pitch_type_id: pod.id,
      max_persons: 4,
      length: 3,
      width: 4.5,
      rates_attributes: [
        {from_date: '2016-01-01', to_date: '2016-05-30', amount: 10},
        {from_date: '2016-06-01', to_date: '2016-12-31', amount: 20}
      ]
    }}

    describe 'owner not signed in' do

      it 'redirects to owner signin page' do
        expect{
          post :update, site_id: site.id, id: pitch.id, pitch: valid_params
        }.not_to change{pitch.reload.name}
        expect(response).to redirect_to(new_owner_session_path)
      end
    end

    describe 'invalid owner' do

      before do
        sign_in invalid_owner, scope: :owner
      end

      it 'get redirected to /sites' do
        expect{
          post :update, site_id: site.id, id: pitch.id, pitch: valid_params
        }.not_to change{pitch.reload.name}
        expect(response).to redirect_to(sites_path)
      end
    end

    describe 'valid owner' do

      before do
        sign_in owner, scope: :owner
      end


      it 'updates pitch when pitch belongs to the site' do
        expect{
          post :update, site_id: site.id, id: pitch.id, pitch: valid_params
        }.to change{pitch.reload.name}

        expect(pitch.type).to eq(pod)
        expect(pitch.max_persons).to eq(4)
        expect(pitch.length).to eq(3)
        expect(pitch.width).to eq(4.5)

        expect(pitch.rates.count).to eq(2)
        (0..1).each do |n|
          expect(pitch.rates[n].from_date).to eq(Date.parse valid_params[:rates_attributes][n][:from_date])
          expect(pitch.rates[n].to_date).to eq(Date.parse valid_params[:rates_attributes][n][:to_date])
          expect(pitch.rates[n].amount).to eq(valid_params[:rates_attributes][n][:amount])
        end
      end

      it 'raises an error when pitch does not belong to the site' do
        expect{
          post :update, site_id: invalid_site.id, id: pitch.id, pitch: valid_params
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'renders edit when params are invalid' do
        expect{
          post :update, site_id: site.id, id: pitch.id, pitch: {name: ''}
        }.not_to change{pitch.reload.name}
        expect(response).to render_template('edit')
      end
    end

  end
end
