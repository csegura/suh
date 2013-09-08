module TimetrackHelper

  def timetrack_hours(timetrack, field=:minutes)
    content_tag :span, :class => timetrack.confirmed? ? :positive : :negative do
      nice_time_in_hours timetrack.send(field)
    end
  end

  def timetrack_status(timetrack)
    content_tag :span, :class => timetrack.confirmed? ? :positive : :negative do
      timetrack.confirmed? ? I18n.t('timetrack.confirmed') : I18n.t('timetrack.unconfirmed')
    end
  end

  def timetrack_flags(timetrack)
    if timetrack.confirmed?
      image_tag('green_square.gif')
    else
      image_tag('orange_square.gif')
    end
  end

  def timetrack_body_text(timetrack)
    nice_html_to_text(timetrack.body.html_safe).truncate(100)
  end

  def can_confirm?(timetrack)
    not timetrack.confirmed? && (current_access.is_owner? || current_access.is_admin? || current_access.id == timetrack.trackable.access.id)
  end

  def timetrack_link(timetrack)
    link_to timetrack_body_text(timetrack), timetrack_path(timetrack)
  end

end