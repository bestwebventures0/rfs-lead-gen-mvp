class DashboardMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.dashboard_mailer.thankyou.subject
  #
  def thankyou(user, pass)
    @greeting = "Hi"
    @user = user
    @pass = pass

    case Rails.env
    when "production"
      @bcc = "marketing@riafin.com"
    end

    mail to: @user.email, bcc: @bcc, subject: "Thank You 🥳 for Filling Up the RiaFin Questionnaire"
  end

  def new_meeting(user, advisor, meeting)
    @greeting = "Hi"
    @user = user
    @advisor = advisor
    @meeting = meeting

    case Rails.env
    when "production"
      @bcc = "sales@riafin.com"
    end

    mail to: @user.email, bcc: @bcc, subject: "Your meeting with #{@advisor.name} has been successfully booked"
  end
end
