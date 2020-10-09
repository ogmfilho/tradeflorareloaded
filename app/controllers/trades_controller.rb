class TradesController < ApplicationController

  def new
    @area = Area.find(params[:area_id])
    if  @area.trades.find_by(user_id: current_user).nil? ||
        @area.trades.find_by(user_id: current_user).status == "Recusada"
      @trade = Trade.new
    else
      redirect_to areas_path, notice: 'Proposta já efetuada para esta área.'
    end
  end

  def create
    @user = current_user
    @trade = Trade.new(trade_params)
    @area = Area.find(params[:area_id])
    if @trade.save
      area = Area.find(@trade.area_id)
      mailint = TradeMailer.with(trade: @trade).newtrade
      maiprop = TradeMailer.with(trade: @trade).newtrade
      redirect_to meu_perfil_path, notice: 'Nova proposta criada.'
    else
      render :new
    end
  end

  def destroy
    @user = current_user
    @trade = Trade.find(params[:id])

    if @trade.user_id != current_user.id
      # raise
      redirect_to meu_perfil_path, notice: "Proposta só pode ser retirada pelo usuário que a criou."
    elsif @trade[:status] == "Aceita"
      redirect_to meu_perfil_path, notice: "Proposta não pôde ser retirada, pois já estava #{@trade[:status].downcase}."
    else
      @trade.destroy
      redirect_to meu_perfil_path, notice: 'Proposta retirada.'
    end
  end

  def aprove
    @user = current_user
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])

    if @area.available?
      @area.trades.each do |trade|
        trade.update(status: "Recusada") unless trade.status == "Recusada"
      end
      @trade.update(status: 'Aceita')
      @area.update(available?: false)
      mail = TradeMailer.with(trade: @trade).aprove
      mail.deliver_now
      redirect_to area_trade_my_deal_path
    else
      redirect_to meu_perfil_path, notice: 'Já há uma proposta aceita para esta área.'
    end
  end

  def refuse
    @user = current_user
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])
    @area.update(available?: true) unless @area.available? == true
    @trade.update(status: "Recusada") unless @trade.status == "Recusada"
    mail = TradeMailer.with(trade: @trade).refuse
    mail.deliver_now
    redirect_to meu_perfil_path, notice: "Proposta recusada."
  end

  def deal
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])
  end

  private

  def trade_params
    params.require(:trade).permit(:user_id, :area_id, :status, :details)
  end

end
