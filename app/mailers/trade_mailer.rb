class TradeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.newtrade.subject
  #
  def newtrade
    @trade = params[:trade]
    mail(
      to:       @trade.user.email,
      subject:  "Nova proposta para área disponibilizada em #{@trade.area.city.name}"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.proposal.subject
  #
  def proposal
    @trade = params[:trade]

    mail(
      to:       @trade.area.user.email,
      subject:  "Nova proposta para área disponibilizada em #{@trade.area.city.name}"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.aprove.subject
  #
  def aprove
    @trade = params[:trade]
    mail(
      to:       @trade.user.email,
      subject:  "Informações sobre sua proposta para área disponibilizada em #{@trade.area.city.name}"
    )
    
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.refuse.subject
  #
  def refuse
    @trade = params[:trade]
    mail(
      to:       @trade.user.email,
      subject:  "Informações sobre sua proposta para área disponibilizada em #{@trade.area.city.name}"
    )
  end
end
