class ActivityObserver < ActiveRecord::Observer
  observe Issue, Comment, Document

  def after_create(subject)
    case subject.class.name
      when "Document"
        log_activity(subject, :uploaded)
      when "Comment"
        log_activity(subject,:commented)
      when "Issue"
        log_activity(subject, :opened)
      else
        log_activity(subject, :created)
    end
  end

  def before_update(subject)
  end

  def after_update(subject)
    if subject.is_a?(Issue) &&
       subject.open_was == true &&
       subject.open == false
          log_activity(subject, :closed)
    elsif subject.is_a?(Issue) &&
          subject.open_was == false &&
          subject.open == true
      log_activity(subject, :reopen)
    else
      # log_activity(subject, :updated)
    end
  end

  def after_destroy(subject)
    log_activity(subject, :deleted)
  end

  private

  def log_activity(subject, action)
    case subject.class.name
      when "Comment"
        user_id = subject.commentable.access.user.id
        company_id = subject.commentable.company.id
      when "Issue"
        user_id = subject.access.user_id
        company_id = subject.company_id
      else
        user_id = subject.access.user_id
        company_id = subject.access.company_id
    end
    Activity.log(subject, subject.access, company_id, user_id, action)
  end

end