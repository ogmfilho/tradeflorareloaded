class AreaMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.area_mailer.create.subject
  #
  def create
    @area = params[:area]

    mail(
      to:       @area.user.email,
      subject:  "Nova área disponibilizada em #{@area.city.name}"
    )
  end
end
