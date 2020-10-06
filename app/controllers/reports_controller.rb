class ReportsController < ApplicationController

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
      redirect_to meu_perfil_path, notice: 'Relato enviado'
    else
      flash.now[:alert] = 'Relato não pode ficar vazio'
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:content)
  end


end
