# Preview all emails at http://localhost:3000/rails/mailers/dashboard_mailer
class DashboardMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/dashboard_mailer/thankyou
  def thankyou
    user = User.first
    pass = "47623rxbrtuyrt3uy"
    DashboardMailer.thankyou(user, pass)
  end

end
