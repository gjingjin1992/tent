class SitesController < ApplicationController

  before_action :authenticate_owner!, except: :show
  before_action :set_site, only: [:edit, :update, :adjust_location]
  before_action :authenticate_for_site!, only: [:edit, :update, :adjust_location]

  def index
    @sites = current_owner.sites.includes(pitches: :type).order(:name)
  end

  def show
    @site = Site.includes(pitches: [:type, :rates, :bookings]).find(params[:id])
  end

  def new
    @site  = Site.new
    6.times { @site.images.build }
    @types = SiteType.all
    @amenities = Amenity.all
  end

  def create
    @site = Site.new(site_params)
    @site.owner = current_owner
    if @site.save
      flash[:notice] = 'Site created successfully'
      redirect_to site_adjust_location_path(@site)
    else
      @types = SiteType.all
      @amenities = Amenity.all
      render 'new'
    end
  end

  def edit
    (6 - @site.images.size).times { @site.images.build }
    @types = SiteType.all
    @amenities = Amenity.all
  end

  def update
    if @site.update_attributes(site_params)
      redirect_to sites_path
    else
      @site.images.reload
      (6 - @site.images.size).times { @site.images.build }
      @types = SiteType.all
      @amenities = Amenity.all
      render 'edit'
    end
  end

  def adjust_location
  end

  private

  def site_params
    params.required(:site).permit(
      :name, :main_image, :site_type_id, :email, :address1, :address2, :address3, :country,
      :county, :city, :town, :postcode, :telephone, :general_desc, :detailed_desc,
      :arrival_time, :departure_time, :latitude, :longitude, amenity_ids: [],
      images_attributes: [:content, :_destroy, :id]
    )
  end

  def set_site
    @site = Site.find(params[:id])
  end

  def authenticate_for_site!
    if @site.owner != current_owner
      flash[:error] = "Not site owner"
      redirect_to sites_path
    end
  end
end
