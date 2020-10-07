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
    @trade = Trade.new(trade_params)
    @area = Area.find(params[:area_id])
    if @trade.save
      area = Area.find(@trade.area_id)

      # area.status = true      mudar o nome de status
      # if area.save
      #  redirect_to user_path(area.user_id), notice: 'Nova trade criada.'
        # end
      mailint = TradeMailer.with(user: current_user, area: @area).newtrade
      maiprop = TradeMailer.with(user: current_user, area: @area).newtrade
      redirect_to my_trades_path, notice: 'Nova trade criada.'
      # redirect_to root_path, notice: 'Nova trade criada.'

    else
      render :new
    end
  end

  def destroy
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
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])

    if @area.available?
      @area.trades.each do |trade|
        trade.update(status: "Recusada") unless trade.status == "Recusada"
      end
      @trade.update(status: 'Aceita')
      @area.update(available?: false)
      mail = TradeMailer.with(user: @trade.user.name, area: @area).aprove
      mail.deliver_now
      redirect_to area_trade_my_deal_path
    else
      redirect_to meu_perfil_path, notice: 'Já há uma proposta aceita para esta área.'
    end






  end

  def refuse
    @trade = Trade.find(params[:trade_id])
    @area = Area.find(params[:area_id])
    @area.update(available?: true) unless @area.available? == true


    @trade.update(status: "Recusada") unless @trade.status == "Concluída" || @trade.status == "Recusada"
    mail = TradeMailer.with(user: @trade.user.name, area: @area).refuse
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
