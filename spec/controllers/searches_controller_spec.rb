require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, search: {guests: 2, bounds: {sw: {lat: 10, lng: 20}, ne: {lat: 30, lng: 50}}}
      expect(response).to have_http_status(:success)
    end
  end

end
