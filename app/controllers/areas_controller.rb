class AreasController < ApplicationController
  #tudo copiado do tradeflorabeta
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @areas = Area.all
    @search = AreaSearch.new
    @states = State.all
    @cities = City.all
    @basins = Basin.all
  end

  def show
    @basins = Basin.all
    @area = Area.find(params[:id])
    @markers = [{
        lat: @area.latitude,
        lng: @area.longitude
      }]
    coordinates = @area.coordinates.split(",").in_groups_of(2)
    @polygon = coordinates.map{ |pair| pair.map{ |coord| coord.to_f } }
  end

  def new
    @area = Area.new
    @basins = Basin.all
    @cities = City.all

  end

  def edit
    @area = Area.find(params[:id])
    @basins = Basin.all
    @cities = City.all
  end

  def create
    @area = Area.new(area_params)
    @area.user = current_user

    if @area.save!
      redirect_to area_path(@area), notice: 'Nova área criada.'
    else
      @basins = Basin.all
      render :new
    end
  end

  def update
      @area = Area.find(params[:id])
      if @area.update!(area_params)
        redirect_to area_path(@area), notice: 'Área modificada.'
      else
        @basins = Basin.all
        render :edit
    end
  end

  def destroy
    @area = Area.find(params[:id])
    @area.destroy

    redirect_to @area, notice: 'Área removida.'
  end

  def aprove
    @area = Area.find(params[:area_id])
    @area.update(status: false)

    redirect_to @area
  end

  private

  def area_params
    params.require(:area).permit(:latitude, :longitude, :description, :address, :extension, :coordinates, :basin_id, :city_id, :photo)
  end
end
