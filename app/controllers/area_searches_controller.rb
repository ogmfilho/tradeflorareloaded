class AreaSearchesController < ApplicationController
  skip_before_action :authenticate_user!


  def create
    @search = AreaSearch.new(search_params) 
    @search.save
    redirect_to area_search_path(@search)
  end

  def show
    @search = AreaSearch.find(params[:id])
  end

  private
  def search_params
    params.require(:area_search).permit(:keywords, :state_id, :city_id, :basin_id, :min_extension, :max_extension)
  end
end