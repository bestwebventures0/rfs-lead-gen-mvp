class ConfirmationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.confirmations_mailer.confirmation_instructions.subject
  #
  # def confirmation_instructions
  #   @greeting = "Hi"

  #   mail to: "to@example.org"
  # end
  
  def confirmation_instructions(user, otp)
    @user = user
    @otp = otp
    email = @user.email.presence || @user.unconfirmed_email
    mail(to: email, subject: "OTP 🔐 to Validate Your Email Address")
  end
end
