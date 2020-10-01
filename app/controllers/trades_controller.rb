class TradesController < ApplicationController

  def new
    @trade = Trade.new
    @area = Area.find(params[:area_id])
    # raise
  end

  def create
    @trade = Trade.new(trade_params)
    @area = Area.find(params[:area_id])
    if @trade.save
      area = Area.find(@trade.area_id)
      # area.status = true      mudar o nome de status
      # if area.save
      #  redirect_to user_path(area.user_id), notice: 'Nova trade criada.'
        # end
      redirect_to my_trades_path, notice: 'Nova trade criada.'
      # redirect_to root_path, notice: 'Nova trade criada.'
    else
      render :new
    end
  end

  def destroy
    @trade = Trade.find(params[:id])

    @trade.destroy

    redirect_to my_proposals_path, notice: 'Proposta recusada.'
  end

  private

  def trade_params
    params.require(:trade).permit(:user_id, :area_id, :status, :details)
  end
end
