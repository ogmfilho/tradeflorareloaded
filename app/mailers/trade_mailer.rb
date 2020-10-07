class TradeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.newtrade.subject
  #
  def newtrade
    @user = params[:user]
    @area = params[:area]
    mail(
      to:       @user.email,
      subject:  "Nova proposta para área disponibilizada em #{@area.city.name}"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.proposal.subject
  #
  def proposal
    @user = params[:user]
    @area = params[:area]

    mail(
      to:       @area.user.email,
      subject:  "Nova proposta para área disponibilizada em #{@area.city.name}"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.aprove.subject
  #
  def aprove
    @user = params[:user]
    @area = params[:area]
    mail(
      to:       @user.email,
      subject:  "Informações sobre sua proposta para área disponibilizada em #{@area.city.name}"
    )
    
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.refuse.subject
  #
  def refuse
    @user = params[:user]
    @area = params[:area]
    mail(
      to:       @user.email,
      subject:  "Informações sobre sua proposta para área disponibilizada em #{@area.city.name}"
    )
  end
end
