class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def trades
    @my_trades = Trade.where(user: current_user)
  end

  def proposals
    @my_proposals = current_user.proposals
  end

  def meu_perfil
    @user = current_user
    @trade = Trade.new
    @area = Area.new
  end

  def maps
    @basins = Basin.all
    @areas = Area.all
    @cities = City.all
    @markers = @areas.map do |area|
      {
        lat: area.latitude,
        lng: area.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { area: area })
      }
    # coordinates = @area.coordinates.split(",").in_groups_of(2)
    # @polygon = coordinates.map{ |pair| pair.map{ |coord| coord.to_f } }
    #colocar para enviar na show quando a seed estiver ok
    end
  end
end
