class ReportsController < ApplicationController
  def index
    @basins = Basin.all
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(@trade.area_id)
    @markers = [{
      lat: @area.latitude,
      lng: @area.longitude
    }]
    coordinates = @area.coordinates.split(",").in_groups_of(2)
    @polygon = coordinates.map { |pair| pair.map { |coord| coord.to_f } }
    @reports = Report.where(trade_id: @trade.id)
  end

  def new
    @report = Report.new
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
      redirect_to area_trade_reports_path, notice: 'Comentário enviado'
    else
      flash.now[:alert] = 'Comentário não pode ficar vazio'
      render :new
    end
  end

  def edit
    @report = Report.find(params[:id])
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])
  end

  def update
    @report = Report.find(params[:id])
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])

    if current_user == @report.user
      if @report.update(report_params)
        redirect_to area_trade_reports_path(@area, @trade, @report), notice: 'Comentário editado'
      else
        flash.now[:alert] = 'Preencha os campos'
        render :edit
      end
    else
      redirect_to meu_perfil_path, notice: 'O comentário pode somente ser editado pelo usuário que o criou'
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @trade = Trade.find(@report.trade_id)
    @area = Area.find(@trade.area_id)
    if current_user == @report.user
      @report.destroy
      redirect_to area_trade_reports_path(@area, @trade), notice: 'Comentário removido.'
    else
      redirect_to meu_perfil_path, notice: 'O comentário pode somente ser excluído pelo usuário que o criou'
    end
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :area_id, :trade_id, :content)
  end
end
