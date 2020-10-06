# Preview all emails at http://localhost:3000/rails/mailers/trade_mailer
class TradeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/newtrade
  def newtrade
    area = Area.first
    user = User.last
    TradeMailer.with(area: area, user: user).newtrade
  end

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/proposal
  def proposal
    area = Area.first
    user = User.last
    TradeMailer.with(area: area, user: user).proposal
  end

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/aprove
  def aprove
    area = Area.first
    user = User.last
    TradeMailer.with(area: area, user: user).aprove
  end

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/refuse
  def refuse
    area = Area.first
    user = User.last
    TradeMailer.with(area: area, user: user).refuse
  end

end
