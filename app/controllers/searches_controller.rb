class SearchesController < ApplicationController
  def index
    @types = PitchType.all.map { |t| [t.name, t.name] }
  end

  def show
    respond_to do |format|
      format.html { assign_params }
      format.js do
        search = Search.new(search_params)
        render json: { sites: search.find_with_min_price.map }, status: :ok
      end
    end
  end

  private

  def search_params
    params
      .require(:search)
      .permit(:pitch_type, :start, :end, :guests, amenities: [], bounds: {sw: [:lng, :lat], ne: [:lng, :lat]})
  end

  def assign_params
    @start  = params[:search][:start]
    @end    = params[:search][:end]
    @guests = params[:search][:guests].to_i
    @pitch_type = params[:search][:pitch_type]
    @amenities  = params[:search][:amenities] || []
    @bounds = {
      sw: {
        lng: params[:search][:bounds][:sw][:lng].to_f,
        lat: params[:search][:bounds][:sw][:lat].to_f,
      },
      ne: {
        lng: params[:search][:bounds][:ne][:lng].to_f,
        lat: params[:search][:bounds][:ne][:lat].to_f,
      }
    }
    @amenity_types = Amenity.all
    @pitch_types = PitchType.all
    @page = params[:page] || 1
  end
end
