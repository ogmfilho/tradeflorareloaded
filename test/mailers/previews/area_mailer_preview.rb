# Preview all emails at http://localhost:3000/rails/mailers/area_mailer
class AreaMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/area_mailer/create
  def create
  	area = Area.first
    AreaMailer.with(area: area).create
  end

end
