class AppMailer < ActionMailer::Base
  default :from => ::AppConfig.mail_from

  helper NiceHelper, ApplicationHelper, IssuesHelper, TimetrackHelper

  def issue_created(issue)
    access = issue.access
    emails = Access.roles_for_company(access.main_company, :owner).map(&:full_email)
    subject = "#{I18n.t('activerecord.models.issue').capitalize} ##{issue.id} #{issue.title}"
    @issue = issue
    mail :to => emails, :subject => subject
  end

  def issue_closed(issue)
    access = issue.access
    emails = Access.roles_for_company(access.main_company,:owner).map(&:full_email)
    subject = "#{I18n.t('issue.close').upcase} #{I18n.t('activerecord.models.issue').capitalize} ##{issue.id} #{issue.title}"
    @issue = issue
    mail :to => emails, :subject => subject
  end

  def comment_created(comment)
    @commentable = comment.commentable
    emails = @commentable.users.map(&:full_email)
    subject = "#{I18n.t('activerecord.models.comment').capitalize} ##{@commentable.id} #{@commentable.activity}"
    @comment = comment
    mail :to => emails, :subject => subject
  end

  def timetrack_created(timetrack)
    @trackable = timetrack.trackable
    emails = Access.roles_for_company(timetrack.company,:admin).map(&:full_email)
    emails << @trackable.user_email
    subject = "#{I18n.t('activerecord.models.timetrack').capitalize} #{@trackable.activity}"
    @timetrack = timetrack
    mail :to => emails, :subject => subject
  end

end