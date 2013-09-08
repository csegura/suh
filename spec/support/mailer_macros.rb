module MailerMacros
  # last delivery mail
  def last_email
    ActionMailer::Base.deliveries.last
  end
  # empty deliveries
  def reset_email
    ActionMailer::Base.deliveries = []
  end
end