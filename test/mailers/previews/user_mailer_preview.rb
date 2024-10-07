# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/send_password
  def send_password
    @user = User.first
    @password = "dghj45435hb5h456h"
    UserMailer.send_password(@user, @password)
  end

end
