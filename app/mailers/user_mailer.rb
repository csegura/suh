class UserMailer < ActionMailer::Base
  default :from => ::AppConfig.mail_from

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.user_mailer.password_reset.subject
    #

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => I18n.t("session.email_password_reset")
  end

  def invitation(user, text, company)
    @user = user
    @text = text
    @company = company
    mail :to => user.email, :subject => I18n.t("session.email_invitation")
  end

end
