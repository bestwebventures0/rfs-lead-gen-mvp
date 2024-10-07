class ApplicationMailer < ActionMailer::Base
  unless Rails.env == "staging"
    default from: "support@riafin.com"
  else
    default from: "staging@riafin.com"
  end
  layout "mailer"
end
