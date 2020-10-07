class ReportsController < ApplicationController

  def index
    @basins = Basin.all
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])
    @markers = [{
      lat: @area.latitude,
      lng: @area.longitude
    }]
    coordinates = @area.coordinates.split(",").in_groups_of(2)
    @polygon = coordinates.map{ |pair| pair.map{ |coord| coord.to_f } }
    @reports = Report.where(trade_id: @trade.id)
  end

  def new
    @report = Report.new()
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])

  end

  def create
    @report = Report.new(report_params)
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])
    @report.user = current_user
    @report.trade = @trade
    if @report.save
      redirect_to area_trade_reports_path, notice: 'Relato enviado'
    else
      flash.now[:alert] = 'Relato não pode ficar vazio'
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :area_id, :trade_id, :content)
  end


end
