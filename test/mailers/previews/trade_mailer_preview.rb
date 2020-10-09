# Preview all emails at http://localhost:3000/rails/mailers/trade_mailer
class TradeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/newtrade
  def newtrade
    trade = Trade.first
    TradeMailer.with(trade: trade).newtrade
  end

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/proposal
  def proposal
    trade = Trade.first 
    TradeMailer.with(trade: trade).proposal
  end

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/aprove
  def aprove
    trade = Trade.first
    TradeMailer.with(trade: trade).aprove
  end

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/refuse
  def refuse
    trade = Trade.first
    TradeMailer.with(trade: trade).refuse
  end

end
