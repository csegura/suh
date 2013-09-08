module ActivityHelper

  def activity_label(activity)
    type = activity.subject_type.downcase
    content_tag :span, :class => "activity_"+type do
      I18n.t('activity.activity.'+type)
    end
  end

  def activity_action(activity)
    I18n.t('activity.action.'+activity.action)
  end

  def activity_purl activity
    url = "/#{activity.subject_type.downcase.pluralize}/#{activity.subject_id}"
    html = ""
    if (not url.blank?) && (not activity.action.eql?("deleted"))
      html << (link_to activity.info, url)
    elsif activity.info.blank?
      html << "n/a"
    else
      html << activity.info
    end
    html.html_safe
  end

  def mobile_activity_purl activity
    url = "/#{activity.subject_type.downcase.pluralize}/#{activity.subject_id}"
    url
  end

  def activity_flags activity
    if activity.is_read?(current_user.id)
      link_to image_tag('green_square.gif'), activity_unread_path(activity.id), :remote => true
    else
      link_to image_tag('orange_square.gif'), activity_read_path(activity.id), :remote => true
    end
  end
end