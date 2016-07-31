class PitchesController < ApplicationController

  before_action :authenticate_owner!
  before_action :set_site
  before_action :authenticate_for_site!
  before_action :destroy_marked_rates!, only: :update

  def new
    @pitch = @site.pitches.build
    @pitch.rates.build
    @types = PitchType.all
  end

  def create
    @pitch = @site.pitches.build(pitch_params)
    if @pitch.save
      flash[:notice] = "Pitch has been successfully created"
      redirect_to sites_path
    else
      @types = PitchType.all
      render 'new'
    end
  end

  def edit
    @pitch = @site.pitches.find(params[:id])
    @types = PitchType.all
  end

  def update
    @pitch = @site.pitches.find(params[:id])
    if @pitch.update_attributes(pitch_update_params)
      flash[:notice] = "Pitch has been updated successfully"
      redirect_to sites_path
    else
      @types = PitchType.all
      render 'edit'
    end
  end

  private

  def pitch_params
    params.require(:pitch).permit(
      :name, :pitch_type_id, :max_persons, :length, :width,
      rates_attributes: [:from_date, :to_date, :amount, :id, :_destroy]
    )
  end

  def destroy_marked_rates!
    # We have to destroy rates marked for destruction first
    # Otherwsie overalpping validation might fail
    if pitch_params && pitch_params[:rates_attributes]
      pitch_params[:rates_attributes].each { |idx, ra| Rate.delete(ra[:id]) if ra && ra[:_destroy] == '1' }
    end
  end

  def pitch_update_params
    # Same as pitch_params but without deleted rates
    if pitch_params && pitch_params[:rates_attributes]
      _params = pitch_params.clone
      _params[:rates_attributes].reject! { |idx, ra| ra && ra[:_destroy] == '1' }
      _params
    else
      pitch_params
    end
  end

  def set_site
    @site = Site.find(params[:site_id])
  end

  def authenticate_for_site!
    if @site.owner != current_owner
      flash[:error] = "Not site owner"
      redirect_to sites_path
    end
  end
end
