class UserMailer < ActionMailer::Base
  default from: "critiqme@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Reset Your Critiq Password"
  end

  def creator_request(user_email)
    mail :to => user_email, :subject => "So you wanna be a creator?"
  end

end
