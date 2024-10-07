# Preview all emails at http://localhost:3000/rails/mailers/confirmations_mailer
class ConfirmationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/confirmations_mailer/confirmation_instructions
  def confirmation_instructions
    @user = User.first
    @otp = 12345678900987654321
    ConfirmationsMailer.confirmation_instructions(@user, @otp)
  end

end
